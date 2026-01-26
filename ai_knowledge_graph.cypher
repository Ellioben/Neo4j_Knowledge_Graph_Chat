    // 人工智能知识图谱 - 精简版 (25个节点)
    // 使用方法：在 Neo4j Browser 中逐条执行这些语句

    // 清空现有数据
    MATCH (n) DETACH DELETE n;

    // ========================================
    // 1. 创建核心理论节点 (4个)
    // ========================================

    CREATE (t1:Theory {
        name: '机器学习理论',
        type: '核心理论',
        description: '从数据中学习规律的算法理论，是人工智能的核心分支',
        key_concepts: '监督学习、无监督学习、强化学习',
        chapter: '第一章',
        difficulty: '基础'
    });

    CREATE (t2:Theory {
        name: '深度学习理论',
        type: '核心理论',
        description: '基于多层神经网络的学习方法，能够自动学习特征表示',
        key_concepts: '神经网络、反向传播、梯度下降',
        chapter: '第二章',
        difficulty: '中等'
    });

    CREATE (t3:Theory {
        name: '自然语言处理理论',
        type: '核心理论',
        description: '让计算机理解、生成和处理人类语言的理论与方法',
        key_concepts: '词嵌入、注意力机制、序列建模',
        chapter: '第三章',
        difficulty: '困难'
    });

    CREATE (t4:Theory {
        name: '计算机视觉理论',
        type: '核心理论',
        description: '让计算机理解和分析图像视频信息的理论与技术',
        key_concepts: '图像识别、目标检测、图像分割',
        chapter: '第四章',
        difficulty: '困难'
    });

    // ========================================
    // 2. 创建重要概念节点 (8个)
    // ========================================

    CREATE (c1:Concept {
        name: '监督学习',
        definition: '使用标注数据训练模型，让模型学习输入到输出的映射关系',
        category: '学习方法',
        related_theory: '机器学习理论'
    });

    CREATE (c2:Concept {
        name: '无监督学习',
        definition: '从无标注数据中发现隐藏的结构和模式',
        category: '学习方法',
        related_theory: '机器学习理论'
    });

    CREATE (c3:Concept {
        name: '强化学习',
        definition: '通过与环境交互，学习最优策略以获得最大累积奖励',
        category: '学习方法',
        related_theory: '机器学习理论'
    });

    CREATE (c4:Concept {
        name: '卷积神经网络',
        definition: '专门用于处理图像数据的深度学习网络结构',
        category: '网络架构',
        related_theory: '深度学习理论'
    });

    CREATE (c5:Concept {
        name: '循环神经网络',
        definition: '专门用于处理序列数据的神经网络，具有记忆功能',
        category: '网络架构',
        related_theory: '深度学习理论'
    });

    CREATE (c6:Concept {
        name: 'Transformer',
        definition: '基于自注意力机制的序列处理架构，革命性地改进了NLP领域',
        category: '网络架构',
        related_theory: '自然语言处理理论'
    });

    CREATE (c7:Concept {
        name: '注意力机制',
        definition: '让模型能够动态关注输入中不同部分的重要性的机制',
        category: '核心机制',
        related_theory: '自然语言处理理论'
    });

    CREATE (c8:Concept {
        name: '目标检测',
        definition: '在图像中定位并识别多个目标的技术',
        category: '视觉任务',
        related_theory: '计算机视觉理论'
    });

    // ========================================
    // 3. 创建实践节点 (6个)
    // ========================================

    CREATE (p1:Practice {
        name: '图像分类应用',
        period: '2012-至今',
        description: '使用深度学习技术对图像进行自动分类，如ImageNet竞赛',
        related_theory: '计算机视觉理论',
        significance: '推动了深度学习在计算机视觉领域的广泛应用'
    });

    CREATE (p2:Practice {
        name: '机器翻译系统',
        period: '2014-至今',
        description: '使用神经网络实现自动翻译，如谷歌翻译、百度翻译',
        related_theory: '自然语言处理理论',
        significance: '大幅提升了机器翻译的质量和实用性'
    });

    CREATE (p3:Practice {
        name: '推荐系统',
        period: '2006-至今',
        description: '基于用户行为和内容特征进行个性化推荐，如Netflix、淘宝推荐',
        related_theory: '机器学习理论',
        significance: '改变了互联网服务的商业模式和用户体验'
    });

    CREATE (p4:Practice {
        name: '自动驾驶技术',
        period: '2015-至今',
        description: '结合计算机视觉、传感器融合和决策控制实现自动驾驶',
        related_theory: '计算机视觉理论',
        significance: '代表了人工智能在复杂环境下的综合应用'
    });

    CREATE (p5:Practice {
        name: '大语言模型',
        period: '2018-至今',
        description: '基于Transformer架构的超大规模语言模型，如GPT、BERT',
        related_theory: '自然语言处理理论',
        significance: '实现了接近人类水平的语言理解和生成能力'
    });

    CREATE (p6:Practice {
        name: '智能游戏AI',
        period: '2016-至今',
        description: '在围棋、星际争霸等游戏中达到超越人类水平的AI系统',
        related_theory: '强化学习',
        significance: '展示了强化学习在复杂决策问题中的强大能力'
    });

    // ========================================
    // 4. 创建领域节点 (4个)
    // ========================================

    CREATE (f1:Field {
        name: '医疗AI',
        focus: '疾病诊断、药物发现、医疗影像分析',
        description: '人工智能在医疗健康领域的应用'
    });

    CREATE (f2:Field {
        name: '金融AI',
        focus: '风险评估、算法交易、欺诈检测',
        description: '人工智能在金融行业的应用'
    });

    CREATE (f3:Field {
        name: '教育AI',
        focus: '个性化学习、智能辅导、自动评分',
        description: '人工智能在教育领域的应用'
    });

    CREATE (f4:Field {
        name: '工业AI',
        focus: '质量检测、预测性维护、智能制造',
        description: '人工智能在工业制造领域的应用'
    });

    // ========================================
    // 5. 创建关系 - 理论发展脉络
    // ========================================

    MATCH (t1:Theory {name: '机器学习理论'}), (t2:Theory {name: '深度学习理论'})
    CREATE (t1)-[:DEVELOPS_INTO {relation: '算法基础'}]->(t2);

    MATCH (t2:Theory {name: '深度学习理论'}), (t3:Theory {name: '自然语言处理理论'})
    CREATE (t2)-[:DEVELOPS_INTO {relation: '网络架构'}]->(t3);

    MATCH (t2:Theory {name: '深度学习理论'}), (t4:Theory {name: '计算机视觉理论'})
    CREATE (t2)-[:DEVELOPS_INTO {relation: '网络架构'}]->(t4);

    // ========================================
    // 6. 创建关系 - 理论包含概念
    // ========================================

    MATCH (t1:Theory {name: '机器学习理论'}), (c1:Concept {name: '监督学习'})
    CREATE (t1)-[:CONTAINS]->(c1);

    MATCH (t1:Theory {name: '机器学习理论'}), (c2:Concept {name: '无监督学习'})
    CREATE (t1)-[:CONTAINS]->(c2);

    MATCH (t1:Theory {name: '机器学习理论'}), (c3:Concept {name: '强化学习'})
    CREATE (t1)-[:CONTAINS]->(c3);

    MATCH (t2:Theory {name: '深度学习理论'}), (c4:Concept {name: '卷积神经网络'})
    CREATE (t2)-[:CONTAINS]->(c4);

    MATCH (t2:Theory {name: '深度学习理论'}), (c5:Concept {name: '循环神经网络'})
    CREATE (t2)-[:CONTAINS]->(c5);

    MATCH (t3:Theory {name: '自然语言处理理论'}), (c6:Concept {name: 'Transformer'})
    CREATE (t3)-[:CONTAINS]->(c6);

    MATCH (t3:Theory {name: '自然语言处理理论'}), (c7:Concept {name: '注意力机制'})
    CREATE (t3)-[:CONTAINS]->(c7);

    MATCH (t4:Theory {name: '计算机视觉理论'}), (c8:Concept {name: '目标检测'})
    CREATE (t4)-[:CONTAINS]->(c8);

    // ========================================
    // 7. 创建关系 - 理论指导实践
    // ========================================

    MATCH (t1:Theory {name: '机器学习理论'}), (p3:Practice {name: '推荐系统'})
    CREATE (t1)-[:GUIDES]->(p3);

    MATCH (c3:Concept {name: '强化学习'}), (p6:Practice {name: '智能游戏AI'})
    CREATE (c3)-[:GUIDES]->(p6);

    MATCH (t2:Theory {name: '深度学习理论'}), (p1:Practice {name: '图像分类应用'})
    CREATE (t2)-[:GUIDES]->(p1);

    MATCH (t3:Theory {name: '自然语言处理理论'}), (p2:Practice {name: '机器翻译系统'})
    CREATE (t3)-[:GUIDES]->(p2);

    MATCH (t3:Theory {name: '自然语言处理理论'}), (p5:Practice {name: '大语言模型'})
    CREATE (t3)-[:GUIDES]->(p5);

    MATCH (t4:Theory {name: '计算机视觉理论'}), (p4:Practice {name: '自动驾驶技术'})
    CREATE (t4)-[:GUIDES]->(p4);

    // ========================================
    // 8. 创建关系 - 概念关联
    // ========================================

    MATCH (c4:Concept {name: '卷积神经网络'}), (c8:Concept {name: '目标检测'})
    CREATE (c4)-[:RELATED_TO {relation: '特征提取'}]->(c8);

    MATCH (c5:Concept {name: '循环神经网络'}), (c6:Concept {name: 'Transformer'})
    CREATE (c5)-[:RELATED_TO {relation: '序列处理'}]->(c6);

    MATCH (c7:Concept {name: '注意力机制'}), (c6:Concept {name: 'Transformer'})
    CREATE (c7)-[:RELATED_TO {relation: '核心组件'}]->(c6);

    MATCH (c1:Concept {name: '监督学习'}), (c4:Concept {name: '卷积神经网络'})
    CREATE (c1)-[:RELATED_TO {relation: '模型训练'}]->(c4);

    // ========================================
    // 9. 创建关系 - 实践应用领域
    // ========================================

    MATCH (p1:Practice {name: '图像分类应用'}), (f1:Field {name: '医疗AI'})
    CREATE (p1)-[:APPLIED_IN]->(f1);

    MATCH (p3:Practice {name: '推荐系统'}), (f2:Field {name: '金融AI'})
    CREATE (p3)-[:APPLIED_IN]->(f2);

    MATCH (p5:Practice {name: '大语言模型'}), (f3:Field {name: '教育AI'})
    CREATE (p5)-[:APPLIED_IN]->(f3);

    MATCH (p4:Practice {name: '自动驾驶技术'}), (f4:Field {name: '工业AI'})
    CREATE (p4)-[:APPLIED_IN]->(f4);

    // ========================================
    // 10. 查询统计信息
    // ========================================

    // 查看所有节点数量
    MATCH (n) RETURN labels(n) as type, count(n) as count ORDER BY type;

    // 查看所有关系统计
    MATCH ()-[r]->() RETURN type(r) as relation_type, count(r) as count ORDER BY count DESC;