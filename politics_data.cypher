// 大学政治教材知识图谱 - Neo4j Cypher 创建语句
// 使用方法：在 Neo4j Browser 中逐条执行这些语句

// 清空现有数据
MATCH (n) DETACH DELETE n;

// ========================================
// 1. 创建核心理论节点
// ========================================

CREATE (t1:Theory {
    name: '马克思主义基本原理',
    type: '核心理论',
    description: '马克思主义哲学、政治经济学和科学社会主义的基本原理',
    key_concepts: '辩证唯物主义、历史唯物主义、剩余价值理论',
    chapter: '第一章',
    difficulty: '基础'
});

CREATE (t2:Theory {
    name: '毛泽东思想',
    type: '核心理论',
    description: '马克思列宁主义在中国的运用和发展，是被实践证明了的关于中国革命和建设的正确的理论原则和经验总结',
    key_concepts: '实事求是、群众路线、独立自主',
    chapter: '第二章',
    difficulty: '基础'
});

CREATE (t3:Theory {
    name: '邓小平理论',
    type: '核心理论',
    description: '马克思列宁主义基本原理同当代中国实践和时代特征相结合的产物',
    key_concepts: '社会主义初级阶段、改革开放、一国两制',
    chapter: '第三章',
    difficulty: '中等'
});

CREATE (t4:Theory {
    name: '三个代表重要思想',
    type: '核心理论',
    description: '中国共产党必须始终代表中国先进生产力的发展要求，代表中国先进文化的前进方向，代表中国最广大人民的根本利益',
    key_concepts: '先进生产力、先进文化、根本利益',
    chapter: '第四章',
    difficulty: '中等'
});

CREATE (t5:Theory {
    name: '科学发展观',
    type: '核心理论',
    description: '以人为本，全面、协调、可持续的发展观',
    key_concepts: '以人为本、全面协调可持续、统筹兼顾',
    chapter: '第五章',
    difficulty: '中等'
});

CREATE (t6:Theory {
    name: '习近平新时代中国特色社会主义思想',
    type: '核心理论',
    description: '马克思主义中国化最新成果，新时代坚持和发展中国特色社会主义的行动指南',
    key_concepts: '中国梦、五位一体、四个全面、新发展理念',
    chapter: '第六章',
    difficulty: '困难'
});

// ========================================
// 2. 创建重要概念节点
// ========================================

CREATE (c1:Concept {
    name: '辩证唯物主义',
    definition: '马克思主义哲学的世界观和方法论，是唯物主义和辩证法的有机统一',
    category: '哲学基础',
    related_theory: '马克思主义基本原理'
});

CREATE (c2:Concept {
    name: '历史唯物主义',
    definition: '马克思主义哲学的社会历史观，认为社会存在决定社会意识',
    category: '哲学基础',
    related_theory: '马克思主义基本原理'
});

CREATE (c3:Concept {
    name: '社会主义初级阶段',
    definition: '中国社会主义社会所处的历史阶段，是中国最大的实际',
    category: '基本国情',
    related_theory: '邓小平理论'
});

CREATE (c4:Concept {
    name: '改革开放',
    definition: '中国社会主义制度的自我完善和发展，是决定当代中国命运的关键抉择',
    category: '基本国策',
    related_theory: '邓小平理论'
});

CREATE (c5:Concept {
    name: '中国梦',
    definition: '实现中华民族伟大复兴的中国梦，是中华民族近代以来最伟大的梦想',
    category: '奋斗目标',
    related_theory: '习近平新时代中国特色社会主义思想'
});

CREATE (c6:Concept {
    name: '五位一体总体布局',
    definition: '经济建设、政治建设、文化建设、社会建设、生态文明建设五位一体',
    category: '战略布局',
    related_theory: '习近平新时代中国特色社会主义思想'
});

CREATE (c7:Concept {
    name: '四个全面战略布局',
    definition: '全面建成小康社会、全面深化改革、全面依法治国、全面从严治党',
    category: '战略布局',
    related_theory: '习近平新时代中国特色社会主义思想'
});

// ========================================
// 3. 创建实践节点
// ========================================

CREATE (p1:Practice {
    name: '新民主主义革命',
    period: '1919-1949',
    description: '中国共产党领导的人民大众反对帝国主义、封建主义和官僚资本主义的革命',
    related_theory: '毛泽东思想',
    significance: '建立了中华人民共和国，实现了民族独立和人民解放'
});

CREATE (p2:Practice {
    name: '社会主义改造',
    period: '1949-1956',
    description: '对农业、手工业和资本主义工商业的社会主义改造',
    related_theory: '毛泽东思想',
    significance: '确立了社会主义基本制度'
});

CREATE (p3:Practice {
    name: '改革开放和现代化建设',
    period: '1978-至今',
    description: '以经济建设为中心，坚持四项基本原则，坚持改革开放',
    related_theory: '邓小平理论',
    significance: '开创了中国特色社会主义道路'
});

CREATE (p4:Practice {
    name: '新时代中国特色社会主义建设',
    period: '2012-至今',
    description: '统筹推进五位一体总体布局，协调推进四个全面战略布局',
    related_theory: '习近平新时代中国特色社会主义思想',
    significance: '推动党和国家事业取得历史性成就'
});

// ========================================
// 4. 创建关系 - 理论发展脉络
// ========================================

MATCH (t1:Theory {name: '马克思主义基本原理'}), (t2:Theory {name: '毛泽东思想'})
CREATE (t1)-[:DEVELOPS_INTO {relation: '继承发展'}]->(t2);

MATCH (t2:Theory {name: '毛泽东思想'}), (t3:Theory {name: '邓小平理论'})
CREATE (t2)-[:DEVELOPS_INTO {relation: '继承发展'}]->(t3);

MATCH (t3:Theory {name: '邓小平理论'}), (t4:Theory {name: '三个代表重要思想'})
CREATE (t3)-[:DEVELOPS_INTO {relation: '继承发展'}]->(t4);

MATCH (t4:Theory {name: '三个代表重要思想'}), (t5:Theory {name: '科学发展观'})
CREATE (t4)-[:DEVELOPS_INTO {relation: '继承发展'}]->(t5);

MATCH (t5:Theory {name: '科学发展观'}), (t6:Theory {name: '习近平新时代中国特色社会主义思想'})
CREATE (t5)-[:DEVELOPS_INTO {relation: '继承发展'}]->(t6);

// ========================================
// 5. 创建关系 - 理论包含概念
// ========================================

MATCH (t1:Theory {name: '马克思主义基本原理'}), (c1:Concept {name: '辩证唯物主义'})
CREATE (t1)-[:CONTAINS]->(c1);

MATCH (t1:Theory {name: '马克思主义基本原理'}), (c2:Concept {name: '历史唯物主义'})
CREATE (t1)-[:CONTAINS]->(c2);

MATCH (t3:Theory {name: '邓小平理论'}), (c3:Concept {name: '社会主义初级阶段'})
CREATE (t3)-[:CONTAINS]->(c3);

MATCH (t3:Theory {name: '邓小平理论'}), (c4:Concept {name: '改革开放'})
CREATE (t3)-[:CONTAINS]->(c4);

MATCH (t6:Theory {name: '习近平新时代中国特色社会主义思想'}), (c5:Concept {name: '中国梦'})
CREATE (t6)-[:CONTAINS]->(c5);

MATCH (t6:Theory {name: '习近平新时代中国特色社会主义思想'}), (c6:Concept {name: '五位一体总体布局'})
CREATE (t6)-[:CONTAINS]->(c6);

MATCH (t6:Theory {name: '习近平新时代中国特色社会主义思想'}), (c7:Concept {name: '四个全面战略布局'})
CREATE (t6)-[:CONTAINS]->(c7);

// ========================================
// 6. 创建关系 - 理论指导实践
// ========================================

MATCH (t2:Theory {name: '毛泽东思想'}), (p1:Practice {name: '新民主主义革命'})
CREATE (t2)-[:GUIDES]->(p1);

MATCH (t2:Theory {name: '毛泽东思想'}), (p2:Practice {name: '社会主义改造'})
CREATE (t2)-[:GUIDES]->(p2);

MATCH (t3:Theory {name: '邓小平理论'}), (p3:Practice {name: '改革开放和现代化建设'})
CREATE (t3)-[:GUIDES]->(p3);

MATCH (t6:Theory {name: '习近平新时代中国特色社会主义思想'}), (p4:Practice {name: '新时代中国特色社会主义建设'})
CREATE (t6)-[:GUIDES]->(p4);

// ========================================
// 7. 创建关系 - 概念关联
// ========================================

MATCH (c1:Concept {name: '辩证唯物主义'}), (c2:Concept {name: '历史唯物主义'})
CREATE (c1)-[:RELATED_TO {relation: '组成部分'}]->(c2);

MATCH (c3:Concept {name: '社会主义初级阶段'}), (c4:Concept {name: '改革开放'})
CREATE (c3)-[:RELATED_TO {relation: '基础条件'}]->(c4);

MATCH (c5:Concept {name: '中国梦'}), (c6:Concept {name: '五位一体总体布局'})
CREATE (c5)-[:RELATED_TO {relation: '实现路径'}]->(c6);

MATCH (c5:Concept {name: '中国梦'}), (c7:Concept {name: '四个全面战略布局'})
CREATE (c5)-[:RELATED_TO {relation: '战略保障'}]->(c7);

// ========================================
// 8. 查询统计信息
// ========================================

// 查看所有节点数量
MATCH (n) RETURN labels(n) as type, count(n) as count ORDER BY type;

// 查看所有关系统计
MATCH ()-[r]->() RETURN type(r) as relation_type, count(r) as count ORDER BY count DESC;

// 查看理论发展脉络
MATCH path = (t1:Theory)-[:DEVELOPS_INTO*]->(t2:Theory) RETURN path;

// 查看某个理论的所有概念
MATCH (t:Theory {name: '习近平新时代中国特色社会主义思想'})-[:CONTAINS]->(c:Concept) RETURN c.name;

// 查看某个理论指导的实践
MATCH (t:Theory)-[:GUIDES]->(p:Practice) RETURN t.name, p.name, p.period;
