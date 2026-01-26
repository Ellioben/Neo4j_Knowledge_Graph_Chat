from py2neo import Graph, Node, Relationship

class Neo4jDB:
    def __init__(self):
        try:
            self.graph = Graph("bolt://localhost:7687", auth=("neo4j", "admin"))
            # 测试连接
            self.graph.run("RETURN 1")
            print("Neo4j数据库连接成功")
        except Exception as e:
            print(f"Neo4j数据库连接失败: {e}")
            print("应用将无法正常运行，请检查Neo4j服务")
            raise e
    
    def create_node(self, label, properties):
        '''创建节点'''
        try:
            node = Node(label, **properties)
            self.graph.create(node)
            return node
        except Exception as e:
            print(f"创建节点失败: {e}")
            return None
    
    def create_relationship(self, start_node, rel_type, end_node, properties=None):
        '''创建关系'''
        try:
            if properties:
                relationship = Relationship(start_node, rel_type, end_node, **properties)
            else:
                relationship = Relationship(start_node, rel_type, end_node)
            self.graph.create(relationship)
            return relationship
        except Exception as e:
            print(f"创建关系失败: {e}")
            return None
    
    def get_all_nodes(self):
        '''获取所有节点'''
        try:
            # 查询所有节点
            query = "MATCH (n) RETURN id(n) as id, labels(n) as labels, properties(n) as properties ORDER BY id(n)"
            result = self.graph.run(query)
            
            nodes = []
            for record in result:
                node = {
                    'id': record['id'],
                    'labels': record['labels'],
                    'properties': dict(record['properties'])
                }
                nodes.append(node)
            
            return nodes
        except Exception as e:
            print(f"获取节点失败: {e}")
            return []
    
    def get_node_relationships(self, node_id):
        '''获取节点的所有关系'''
        try:
            query = """
            MATCH (a)-[r]->(b)
            WHERE id(a) = $node_id OR id(b) = $node_id
            RETURN a, r, b, 
                   id(a) as start_id, id(b) as end_id,
                   type(r) as rel_type, properties(r) as rel_properties,
                   labels(a) as start_labels, labels(b) as end_labels,
                   properties(a) as start_properties, properties(b) as end_properties
            ORDER BY start_id, end_id
            """
            
            result = self.graph.run(query, node_id=node_id)
            relationships = []
            
            for record in result:
                relationship = {
                    'start_node': {
                        'id': record['start_id'],
                        'labels': record['start_labels'],
                        'properties': dict(record['start_properties'])
                    },
                    'relationship': {
                        'type': record['rel_type'],
                        'properties': dict(record['rel_properties'])
                    },
                    'end_node': {
                        'id': record['end_id'],
                        'labels': record['end_labels'],
                        'properties': dict(record['end_properties'])
                    }
                }
                relationships.append(relationship)
            
            return relationships
        except Exception as e:
            print(f"获取节点关系失败: {e}")
            return []
    
    def search_nodes(self, keyword):
        '''搜索节点'''
        try:
            # 在节点的所有属性中搜索关键词
            query = """
            MATCH (n)
            WHERE any(prop in keys(n) 
                   WHERE toString(n[prop]) CONTAINS $keyword)
            RETURN id(n) as id, labels(n) as labels, properties(n) as properties
            ORDER BY id(n)
            """
            
            result = self.graph.run(query, keyword=keyword)
            nodes = []
            
            for record in result:
                node = {
                    'id': record['id'],
                    'labels': record['labels'],
                    'properties': dict(record['properties'])
                }
                nodes.append(node)
            
            return nodes
        except Exception as e:
            print(f"搜索节点失败: {e}")
            return []
    
    def delete_node(self, node_id):
        '''删除节点'''
        try:
            # 删除真实数据库中的节点
            self.graph.run("MATCH (n) WHERE id(n) = $node_id DETACH DELETE n", node_id=node_id)
            return True
        except Exception as e:
            print(f"删除节点失败: {e}")
            return False
    
    def update_node(self, node_id, properties):
        '''更新节点属性'''
        try:
            # 构建SET语句
            set_clauses = []
            for key, value in properties.items():
                set_clauses.append(f"n.{key} = ${key}")
            
            if not set_clauses:
                return False
            
            query = f"""
            MATCH (n) WHERE id(n) = $node_id
            SET {', '.join(set_clauses)}
            RETURN n
            """
            
            # 添加node_id到参数中
            properties['node_id'] = node_id
            
            result = self.graph.run(query, properties)
            # 检查是否有结果
            return len(list(result)) > 0
            
        except Exception as e:
            print(f"更新节点失败: {e}")
            return False
    
    def get_real_graph_data(self):
        '''获取图谱数据用于可视化'''
        try:
            # 查询所有节点
            nodes_query = """
            MATCH (n)
            RETURN 
                id(n) as id,
                labels(n) as labels,
                properties(n) as properties
            ORDER BY id(n)
            """
            nodes_result = self.graph.run(nodes_query)
            
            nodes = []
            for record in nodes_result:
                node = {
                    'id': int(record['id']),  # 确保ID是整数
                    'labels': record['labels'],
                    'properties': dict(record['properties'])
                }
                nodes.append(node)
            
            # 查询所有关系
            relationships_query = """
            MATCH (a)-[r]->(b)
            RETURN 
                id(r) as id,
                type(r) as type,
                properties(r) as properties,
                id(a) as start_node,
                id(b) as end_node,
                labels(a) as start_labels,
                labels(b) as end_labels
            ORDER BY id(r)
            """
            relationships_result = self.graph.run(relationships_query)
            
            relationships = []
            for record in relationships_result:
                relationship = {
                    'id': int(record['id']),  # 确保ID是整数
                    'type': record['type'],
                    'properties': dict(record['properties']),
                    'start_node': int(record['start_node']),  # 确保ID是整数
                    'end_node': int(record['end_node']),      # 确保ID是整数
                    'start_labels': record['start_labels'],
                    'end_labels': record['end_labels']
                }
                relationships.append(relationship)
            
            # 转换为统一格式（与模拟数据格式一致）
            edges = []
            for rel in relationships:
                edge = {
                    'from': rel['start_node'],
                    'to': rel['end_node'],
                    'label': rel['type'],
                    'title': rel['type']
                }
                edges.append(edge)
            
            return {
                'nodes': nodes,
                'edges': edges  # 返回edges而不是relationships，保持格式一致
            }
            
        except Exception as e:
            print(f"查询图谱数据失败: {e}")
            return {'nodes': [], 'edges': []}

# 创建数据库实例
db = Neo4jDB()