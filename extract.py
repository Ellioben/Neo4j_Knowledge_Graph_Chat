# requirements.txt
# PyPDF2==3.0.0 (用于基础PDF解析)
# python-docx==1.1.0 (用于Word解析，可选)
# neo4j==5.20.0

import re
from PyPDF2 import PdfReader
from neo4j import GraphDatabase

# ========== 第一步：从PDF解析文本 ==========
def extract_text_from_pdf(pdf_path):
    """读取PDF，返回纯文本字符串"""
    text = ""
    reader = PdfReader(pdf_path)
    for page in reader.pages:
        text += page.extract_text() + "\n"
    return text

# ========== 第二步：处理文本，提取信息 ==========
def extract_knowledge_from_text(text):
    """
    一个极其简单的规则示例：寻找“概念：定义”模式
    你可以根据你的教材格式自定义，这是最灵活的一步
    """
    entities = []
    relationships = []
    
    # 示例1：寻找用引号或冒号标注的概念
    # 例如：“马克思主义：是...的理论体系”
    concept_pattern = r'["“](.+?)["”]\s*[:：]\s*(.+)|(.+?)[:：]\s*(.+)'
    for match in re.finditer(concept_pattern, text):
        groups = match.groups()
        concept = groups[0] or groups[2]
        definition = groups[1] or groups[3]
        if concept and definition:
            entities.append(("Concept", concept, {"definition": definition[:100]})) # 存前100字
    
    # 示例2：寻找理论名称（更精确的规则）
    theory_list = ["马克思主义", "毛泽东思想", "邓小平理论", "三个代表重要思想"]
    for theory in theory_list:
        if theory in text:
            entities.append(("Theory", theory, {}))
            # 简单的关系：如果“马克思”和“马克思主义”同时出现，建立关系
            if "马克思" in text and theory == "马克思主义":
                relationships.append(("PERSON", "马克思", "FOUNDED", "THEORY", theory))
    
    return entities, relationships

# ========== 第三步：将信息存入Neo4j ==========
def save_to_neo4j(entities, relationships, uri, user, password):
    driver = GraphDatabase.driver(uri, auth=(user, password))
    
    def create_entity(tx, label, name, properties):
        props_str = ", ".join([f'{k}: "{v}"' for k, v in properties.items()])
        query = f"MERGE (n:{label} {{name: $name}})"
        if properties:
            query = f"MERGE (n:{label} {{name: $name}}) SET n += $properties"
        tx.run(query, name=name, properties=properties)
    
    def create_relationship(tx, from_label, from_name, rel_type, to_label, to_name):
        query = f"""
        MATCH (a:{from_label} {{name: $from_name}})
        MATCH (b:{to_label} {{name: $to_name}})
        MERGE (a)-[r:{rel_type}]->(b)
        """
        tx.run(query, from_name=from_name, to_name=to_name)
    
    with driver.session() as session:
        # 创建实体节点
        for label, name, props in entities:
            session.execute_write(create_entity, label, name, props)
        print(f"已创建 {len(entities)} 个实体")
        
        # 创建关系
        for from_label, from_name, rel_type, to_label, to_name in relationships:
            session.execute_write(create_relationship, from_label, from_name, rel_type, to_label, to_name)
        print(f"已创建 {len(relationships)} 条关系")
    
    driver.close()

# ========== 主程序 ==========
if __name__ == "__main__":
    # 1. 配置你的Neo4j连接
    NEO4J_URI = "bolt://localhost:7687"
    NEO4J_USER = "neo4j"
    NEO4J_PASSWORD = "你的密码"
    
    # 2. 指定你的教材PDF路径
    PDF_FILE = "大学政治教材.pdf"
    
    # 3. 运行流程
    print("正在解析PDF...")
    raw_text = extract_text_from_pdf(PDF_FILE)
    print(f"提取到 {len(raw_text)} 个字符")
    
    print("正在分析文本，提取知识点...")
    entities, relationships = extract_knowledge_from_text(raw_text)
    
    print("正在存入Neo4j...")
    save_to_neo4j(entities, relationships, NEO4J_URI, NEO4J_USER, NEO4J_PASSWORD)
    print("完成！")

# 示例：用DeepSeek API智能提取（需要安装openai库并配置API_KEY）
from openai import OpenAI

client = OpenAI(api_key="your_deepseek_key", base_url="https://api.deepseek.com")

def extract_with_llm(text_chunk):
    prompt = f"""
    请从以下政治教材文本中提取核心知识点。请严格按照JSON格式输出，包含两个列表：
    1. `entities`: 列表中的每个元素是一个字典，包含 `label` (类型，如 Theory/Person/Concept) 和 `name` (名称)。
    2. `relationships`: 列表中的每个元素是一个字典，包含 `from` (起点实体名)、`rel` (关系类型)、`to` (终点实体名)。

    文本：{text_chunk[:3000]}  # 每次处理前3000字符，避免超出上下文
    """
    response = client.chat.completions.create(
        model="deepseek-chat",
        messages=[{"role": "user", "content": prompt}],
        response_format={"type": "json_object"}
    )
    result = json.loads(response.choices[0].message.content)
    return result.get("entities", []), result.get("relationships", [])