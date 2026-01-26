import requests
import json
import os

class DeepSeekQA:
    def __init__(self, api_key=None, base_url="https://api.deepseek.com", model="deepseek-coder"):
        """
        初始化 DeepSeek API 客户端
        :param api_key: DeepSeek API 密钥
        :param base_url: API 基础 URL
        :param model: 模型名称
        """
        self.api_key = api_key or os.getenv('DEEPSEEK_API_KEY')
        self.base_url = base_url
        self.model = model
        
        if not self.api_key:
            print("警告: 未设置 DEEPSEEK_API_KEY，请设置环境变量或传入 api_key 参数")
        else:
            print(f"DeepSeek API 客户端初始化成功，使用模型: {model}")
        
        # 系统提示词
        self.cypher_system_prompt = """你是一个Neo4j数据库专家，请根据用户的问题生成Cypher查询语句。
数据库模式：
- 节点类型：
  * Theory {name: string, type: string, description: string, key_concepts: string, chapter: string, difficulty: string}
  * Concept {name: string, definition: string, category: string, related_theory: string}
  * Practice {name: string, period: string, description: string, related_theory: string, significance: string}
- 关系类型：
  * (Theory)-[:DEVELOPS_INTO]->(Theory)
  * (Theory)-[:CONTAINS]->(Concept)
  * (Concept)-[:GUIDES]->(Practice)
  * (Practice)-[:REFLECTS]->(Theory)

重要说明：
1. 邓小平理论、三个代表重要思想、科学发展观、马克思主义基本原理、毛泽东思想、习近平新时代中国特色社会主义思想等都是 Theory 类型的节点
2. Concept 节点有属性：name, definition, category, related_theory
3. Practice 节点有属性：name, period, description, related_theory, significance
4. 不要假设节点类型为 Technology 或 CoreTheory，应该使用 Theory, Concept, Practice
5. 查询时应该使用正确的节点标签和属性名

请只返回Cypher查询语句，不要包含其他任何解释或说明。"""

    def _call_api(self, messages, temperature=0.3):
        """调用 DeepSeek API"""
        if not self.api_key:
            return None, "API Key 未设置"
            
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        
        data = {
            "model": self.model,
            "messages": messages,
            "temperature": temperature,
            "max_tokens": 450  # 支持约200字左右回答
        }
        
        try:
            response = requests.post(
                f"{self.base_url}/v1/chat/completions",
                headers=headers,
                json=data,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                return result['choices'][0]['message']['content'], None
            else:
                error_msg = f"API 调用失败: {response.status_code} - {response.text}"
                return None, error_msg
                
        except requests.exceptions.RequestException as e:
            return None, f"网络请求失败: {str(e)}"

    def generate_cypher(self, question):
        """使用 DeepSeek API 生成 Cypher 查询"""
        messages = [
            {"role": "system", "content": self.cypher_system_prompt},
            {"role": "user", "content": f"问题：{question}\n\n请生成对应的 Cypher 查询语句："}
        ]
        
        result, error = self._call_api(messages, temperature=0.3)
        
        if error:
            print(f"生成 Cypher 查询时出错: {error}")
            return None
            
        # 清理生成的查询，只保留 Cypher 语句
        lines = result.strip().split('\n')
        cypher_lines = []
        in_cypher = False
        
        for line in lines:
            line = line.strip()
            if line.upper().startswith('MATCH') or line.upper().startswith('CREATE') or line.upper().startswith('RETURN'):
                in_cypher = True
                cypher_lines.append(line)
            elif in_cypher and line:
                cypher_lines.append(line)
            elif in_cypher and not line:
                break
        
        return '\n'.join(cypher_lines) if cypher_lines else None

    def generate_answer_with_context(self, question, query_results, context_info):
        """使用节点上下文信息生成更准确的回答"""
        # 构建上下文信息
        context_text = ""
        if context_info:
            context_text = "\n\n相关节点信息：\n"
            for i, node_context in enumerate(context_info, 1):
                node = node_context['node']
                relationships = node_context['relationships']
                
                context_text += f"\n{i}. 节点：{node.get('properties', {}).get('name', '未知节点')}\n"
                context_text += f"   类型：{', '.join(node.get('labels', []))}\n"
                
                # 添加节点属性
                properties = node.get('properties', {})
                for key, value in properties.items():
                    if key != 'name':
                        context_text += f"   {key}：{value}\n"
                
                # 添加关系信息
                if relationships:
                    context_text += "   相关关系：\n"
                    for rel in relationships[:5]:  # 限制关系数量
                        rel_type = rel.get('type', '')
                        rel_desc = rel.get('properties', {}).get('relation', rel_type)
                        start_node = rel.get('start_node', {})
                        end_node = rel.get('end_node', {})
                        
                        if start_node.get('properties', {}).get('name'):
                            context_text += f"   - {start_node['properties']['name']} --[{rel_desc}]--> {end_node.get('properties', {}).get('name', '未知')}\n"
        
        messages = [
            {"role": "system", "content": """你是一个专业的AI知识图谱助手。请根据用户的问题、查询结果和相关节点信息，提供准确的回答。

回答要求：
1. 回答控制在200字左右
2. 基于提供的节点信息和关系进行回答
3. 语言简洁明了，突出核心信息
4. 直接回答问题，不要冗余解释

请用中文回答，控制在200字左右。"""},
            {"role": "user", "content": f"问题：{question}\n\n查询结果：\n{json.dumps(query_results, ensure_ascii=False, indent=2)}{context_text}\n\n请根据以上信息，用200字左右简洁回答用户的问题。"}
        ]
        
        result, error = self._call_api(messages, temperature=0.7)
        
        if error:
            print(f"生成回答时出错: {error}")
            return f"抱歉，生成回答时遇到了问题：{error}"
        
        # 进一步截断回答，确保不超过约220字（给“200字左右”留一点余量）
        answer = result.strip()
        if len(answer) > 220:
            answer = answer[:217] + "..."
        
        return answer

    def generate_answer(self, question, query_results):
        """使用 DeepSeek API 生成自然语言回答"""
        messages = [
            {"role": "system", "content": "你是一个知识图谱助手，请根据查询结果用自然语言回答问题。如果结果为空，请友好地告知用户没有找到相关信息。"},
            {"role": "user", "content": f"问题：{question}\n\n查询结果：\n{json.dumps(query_results, ensure_ascii=False, indent=2)}\n\n请根据以上结果，用自然语言回答问题。"}
        ]
        
        result, error = self._call_api(messages, temperature=0.7)
        
        if error:
            print(f"生成回答时出错: {error}")
            return "抱歉，生成回答时出错了。"
            
        return result.strip()
