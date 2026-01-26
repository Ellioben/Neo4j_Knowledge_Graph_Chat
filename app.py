from flask import Flask, jsonify, request, render_template, Response
from neo4j_db import Neo4jDB
import re
import os
from deepseek_qa import DeepSeekQA
import json

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False  # 禁用 ASCII 转义，返回正常中文
app.config['JSON_ENSURE_ASCII'] = False  # 额外确保

def json_response(data):
    """返回正确的中文 JSON 响应"""
    return Response(
        response=json.dumps(data, ensure_ascii=False),
        status=200,
        mimetype='application/json; charset=utf-8'
    )

def extract_entity(text, entities):
    """从文本中提取实体"""
    for entity in entities:
        if entity in text:
            return entity
    return None

# 初始化数据库连接
db = Neo4jDB()

# 初始化DeepSeek模型
print("正在加载DeepSeek模型...")
# 请在这里替换为您的实际 API Key
deepseek_api_key = "sk-844eeff7ccb54aa587b0c46928f20d45"  # 替换为您的实际 API Key
deepseek_qa = DeepSeekQA(api_key=deepseek_api_key)
print("DeepSeek模型加载完成")

@app.route('/')
def index():
    '''主页'''
    return render_template('index.html')

@app.route('/api/nodes')
def get_nodes():
    '''获取所有节点'''
    nodes = db.get_all_nodes()
    return json_response({
        'success': True,
        'data': nodes,
        'count': len(nodes)
    })

@app.route('/api/node/<int:node_id>')
def get_node_detail(node_id):
    '''获取节点详情'''
    # 首先获取节点本身的信息
    all_nodes = db.get_all_nodes()
    node_info = None
    
    for node in all_nodes:
        if node['id'] == node_id:
            node_info = node
            break
    
    if not node_info:
        return json_response({
            'success': False,
            'message': '节点不存在'
        })
    
    # 获取节点的关系
    relationships = db.get_node_relationships(node_id)
    
    return json_response({
        'success': True,
        'data': {
            'node': node_info,
            'relationships': relationships
        }
    })

@app.route('/api/search')
def search_nodes():
    '''搜索节点'''
    keyword = request.args.get('keyword', '')
    if not keyword:
        return json_response({
            'success': False,
            'message': '请输入搜索关键词'
        })
    
    nodes = db.search_nodes(keyword)
    return json_response({
        'success': True,
        'data': nodes,
        'count': len(nodes)
    })

@app.route('/api/update_node/<int:node_id>', methods=['PUT'])
def update_node(node_id):
    '''更新节点信息'''
    try:
        data = request.get_json()
        if not data:
            return json_response({
                'success': False,
                'message': '请提供更新数据'
            })
        
        success = db.update_node(node_id, data)
        if success:
            return json_response({
                'success': True,
                'message': '节点更新成功'
            })
        else:
            return json_response({
                'success': False,
                'message': '节点更新失败'
            })
    except Exception as e:
        return json_response({
            'success': False,
            'message': f'更新节点时出错: {str(e)}'
        })

@app.route('/api/delete_node/<int:node_id>')
def delete_node(node_id):
    '''删除节点'''
    success = db.delete_node(node_id)
    if success:
        return json_response({
            'success': True,
            'message': '节点删除成功'
        })
    else:
        return json_response({
            'success': False,
            'message': '节点删除失败'
        })

@app.route('/api/real_graph_data')
def get_real_graph_data():
    '''获取真实的Neo4j图谱数据（不使用模拟数据）'''
    try:
        data = db.get_real_graph_data()
        response = {
            'success': True,
            'data': data,
            'count': {
                'nodes': len(data['nodes']),
                'relationships': len(data['edges'])
            }
        }
        return json_response(response)
    except Exception as e:
        return json_response({
            'success': False,
            'message': f'获取真实图谱数据失败: {str(e)}'
        })

@app.route('/api/graph_data')
def get_graph_data():
    '''获取图谱数据用于可视化'''
    print("收到获取图谱数据的请求")
    try:
        print("正在获取所有节点...")
        nodes = db.get_all_nodes()
        print(f"成功获取到 {len(nodes)} 个节点")
        
        # 转换数据格式用于可视化
        graph_data = {
            'nodes': [],
            'edges': []
        }
        
        node_ids = {}
        for i, node in enumerate(nodes):
            # 优先使用自定义ID，如果没有则使用Neo4j内部ID
            custom_id = node.get('properties', {}).get('id')
            node_id = str(custom_id) if custom_id else str(node['id'])
            node_ids[node['id']] = i
            
            # 获取节点标签
            node_label = node['properties'].get('name') or node['properties'].get('title') or f"Node {node['id']}"
            
            graph_data['nodes'].append({
                'id': node_id,
                'label': node_label,
                'title': node_label,
                'group': node['labels'][0] if node['labels'] else 'Unknown',
                'properties': node['properties']
            })
        
        print(f"转换后的节点数据: {len(graph_data['nodes'])} 个节点")
        
        # 创建Neo4j内部ID到自定义ID的映射
        internal_to_custom_id = {}
        for node in nodes:
            internal_id = node['id']
            custom_id = node.get('properties', {}).get('id')
            if custom_id:
                internal_to_custom_id[internal_id] = str(custom_id)
            else:
                internal_to_custom_id[internal_id] = str(internal_id)
        
        # 获取关系数据
        processed_edges = set()  # 用于去重
        print("正在获取节点关系...")
        
        for node in nodes:
            try:
                relationships = db.get_node_relationships(node['id'])
                print(f"节点 {node['id']} 有 {len(relationships)} 个关系")
                
                for rel in relationships:
                    try:
                        start_internal_id = rel['start_node']['id']
                        end_internal_id = rel['end_node']['id']
                        rel_type = rel['relationship']['type']
                        
                        # 转换为自定义ID
                        start_custom_id = internal_to_custom_id.get(start_internal_id, str(start_internal_id))
                        end_custom_id = internal_to_custom_id.get(end_internal_id, str(end_internal_id))
                        
                        edge_key = f"{start_custom_id}-{rel_type}-{end_custom_id}"
                        
                        if edge_key not in processed_edges:
                            graph_data['edges'].append({
                                'from': start_custom_id,
                                'to': end_custom_id,
                                'label': rel_type,
                                'title': str(rel['relationship']['properties']) or rel_type
                            })
                            processed_edges.add(edge_key)
                    except Exception as rel_error:
                        print(f"处理关系时出错: {rel_error}")
                        print(f"关系数据: {rel}")
                        continue
                        
            except Exception as node_error:
                print(f"获取节点 {node['id']} 的关系时出错: {node_error}")
                continue
        
        print(f"最终数据 - 节点数: {len(graph_data['nodes'])}, 边数: {len(graph_data['edges'])}")
        
        response = {
            'success': True,
            'data': graph_data
        }
        print("返回响应数据")
        return json_response(response)
        
    except Exception as e:
        error_msg = f"获取图谱数据失败: {str(e)}"
        print(error_msg)
        import traceback
        traceback.print_exc()  # 打印完整的堆栈跟踪
        
        return json_response({
            'success': False,
            'message': error_msg
        })

@app.route('/api/qa')
def knowledge_qa():
    """知识图谱问答 - 使用DeepSeek模型"""
    question = request.args.get('question', '').strip()
    if not question:
        return json_response({'success': False, 'message': '问题不能为空'})
    
    try:
        # 1. Generate Cypher query
        print(f"正在为问题生成Cypher查询: {question}")
        cypher_query = deepseek_qa.generate_cypher(question)
        if not cypher_query:
            return json_response({
                'success': False,
                'message': '无法理解您的问题，请尝试用其他方式提问。'
            })
        
        print(f"生成的Cypher查询: {cypher_query}")
        
        # 2. Execute the query
        result = db.graph.run(cypher_query).data()
        print(f"查询结果: {result}")
        
        # 3. Generate natural language answer
        answer = deepseek_qa.generate_answer(question, result)
        print(f"生成的回答: {answer}")
        
        return json_response({
            'success': True,
            'answer': answer,
            'query': cypher_query,
            'data': result
        })
        
    except Exception as e:
        error_msg = f"处理问题时出错: {str(e)}"
        print(error_msg)
        import traceback
        traceback.print_exc()
        return json_response({
            'success': False,
            'message': '处理您的问题时出错了，请稍后再试。'
        })

if __name__ == '__main__':
    import argparse
    
    # 设置命令行参数
    parser = argparse.ArgumentParser(description='启动知识图谱应用')
    parser.add_argument('--port', type=int, default=5001, help='指定服务器端口 (默认: 5001)')
    args = parser.parse_args()
    
    print(f"启动Flask应用，监听端口 {args.port}...")
    app.run(host='0.0.0.0', port=args.port, debug=False)