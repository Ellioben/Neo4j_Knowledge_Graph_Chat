// ============================================
// 人工智能知识图谱 - Neo4j Cypher 数据导入脚本
// ============================================

// 清空数据库（可选，谨慎使用）
// MATCH (n) DETACH DELETE n;

// ============================================
// 创建约束和索引（提升查询性能）
// ============================================

CREATE CONSTRAINT IF NOT EXISTS FOR (n:Course) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Chapter) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Concept) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Detail) REQUIRE n.id IS UNIQUE;

CREATE INDEX IF NOT EXISTS FOR (n:Course) ON (n.label);
CREATE INDEX IF NOT EXISTS FOR (n:Chapter) ON (n.label);
CREATE INDEX IF NOT EXISTS FOR (n:Concept) ON (n.label);
CREATE INDEX IF NOT EXISTS FOR (n:Detail) ON (n.label);

// ============================================
// 创建节点 - 课程根节点
// ============================================

CREATE (ai:Course {
  id: '1',
  label: '人工智能',
  description: '人工智能导论与核心技术',
  chapter: '课程根节点'
});

// ============================================
// 创建节点 - 章节层级
// ============================================

CREATE (ml:Chapter {
  id: '2',
  label: '机器学习',
  description: '从数据中学习规律的算法',
  chapter: '第一章'
});

CREATE (dl:Chapter {
  id: '3',
  label: '深度学习',
  description: '基于神经网络的学习方法',
  chapter: '第二章'
});

CREATE (nlp:Chapter {
  id: '4',
  label: '自然语言处理',
  description: '让机器理解人类语言',
  chapter: '第三章'
});

CREATE (cv:Chapter {
  id: '5',
  label: '计算机视觉',
  description: '让机器理解图像和视频',
  chapter: '第四章'
});

// ============================================
// 创建节点 - 机器学习概念
// ============================================

CREATE (supervised:Concept {
  id: '6',
  label: '监督学习',
  description: '使用标注数据训练模型',
  chapter: '第一章'
});

CREATE (unsupervised:Concept {
  id: '7',
  label: '无监督学习',
  description: '从无标注数据中发现模式',
  chapter: '第一章'
});

CREATE (rl:Concept {
  id: '8',
  label: '强化学习',
  description: '通过奖励信号学习决策',
  chapter: '第一章'
});

// ============================================
// 创建节点 - 深度学习概念
// ============================================

CREATE (nn:Concept {
  id: '9',
  label: '神经网络',
  description: '模拟生物神经元的计算模型',
  chapter: '第二章'
});

CREATE (cnn:Concept {
  id: '10',
  label: 'CNN',
  description: '卷积神经网络，擅长处理图像',
  chapter: '第二章'
});

CREATE (rnn:Concept {
  id: '11',
  label: 'RNN',
  description: '循环神经网络，处理序列数据',
  chapter: '第二章'
});

// ============================================
// 创建节点 - NLP概念
// ============================================

CREATE (transformer:Concept {
  id: '12',
  label: 'Transformer',
  description: '基于注意力机制的架构',
  chapter: '第三章'
});

CREATE (embedding:Concept {
  id: '13',
  label: '词嵌入',
  description: '将词语映射为向量表示',
  chapter: '第三章'
});

// ============================================
// 创建节点 - 计算机视觉概念
// ============================================

CREATE (detection:Concept {
  id: '14',
  label: '目标检测',
  description: '定位和识别图像中的物体',
  chapter: '第四章'
});

CREATE (segmentation:Concept {
  id: '15',
  label: '图像分割',
  description: '将图像划分为不同区域',
  chapter: '第四章'
});

// ============================================
// 创建节点 - 机器学习知识点
// ============================================

CREATE (linear_reg:Detail {
  id: '16',
  label: '线性回归',
  description: '预测连续数值的基础算法',
  chapter: '第一章'
});

CREATE (decision_tree:Detail {
  id: '17',
  label: '决策树',
  description: '基于特征分裂的分类方法',
  chapter: '第一章'
});

CREATE (kmeans:Detail {
  id: '18',
  label: 'K-Means',
  description: '经典的聚类算法',
  chapter: '第一章'
});

CREATE (qlearning:Detail {
  id: '19',
  label: 'Q-Learning',
  description: '基于值函数的强化学习',
  chapter: '第一章'
});

// ============================================
// 创建节点 - 深度学习知识点
// ============================================

CREATE (backprop:Detail {
  id: '20',
  label: '反向传播',
  description: '神经网络训练的核心算法',
  chapter: '第二章'
});

CREATE (gradient:Detail {
  id: '21',
  label: '梯度下降',
  description: '优化损失函数的迭代方法',
  chapter: '第二章'
});

CREATE (resnet:Detail {
  id: '22',
  label: 'ResNet',
  description: '残差网络，解决深层网络退化',
  chapter: '第二章'
});

CREATE (lstm:Detail {
  id: '23',
  label: 'LSTM',
  description: '长短期记忆网络',
  chapter: '第二章'
});

// ============================================
// 创建节点 - NLP知识点
// ============================================

CREATE (attention:Detail {
  id: '24',
  label: '注意力机制',
  description: '动态聚焦重要信息',
  chapter: '第三章'
});

CREATE (bert:Detail {
  id: '25',
  label: 'BERT',
  description: '双向编码器预训练模型',
  chapter: '第三章'
});

CREATE (gpt:Detail {
  id: '26',
  label: 'GPT',
  description: '生成式预训练语言模型',
  chapter: '第三章'
});

CREATE (word2vec:Detail {
  id: '27',
  label: 'Word2Vec',
  description: '词向量训练经典方法',
  chapter: '第三章'
});

// ============================================
// 创建节点 - 计算机视觉知识点
// ============================================

CREATE (yolo:Detail {
  id: '28',
  label: 'YOLO',
  description: '实时目标检测算法',
  chapter: '第四章'
});

CREATE (unet:Detail {
  id: '29',
  label: 'U-Net',
  description: '医学图像分割网络',
  chapter: '第四章'
});

// ============================================
// 创建关系 - 包含关系 (CONTAINS)
// ============================================

// 课程包含章节
MATCH (a:Course {id: '1'}), (b:Chapter {id: '2'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Course {id: '1'}), (b:Chapter {id: '3'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Course {id: '1'}), (b:Chapter {id: '4'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Course {id: '1'}), (b:Chapter {id: '5'}) CREATE (a)-[:CONTAINS]->(b);

// 机器学习章节包含概念
MATCH (a:Chapter {id: '2'}), (b:Concept {id: '6'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '2'}), (b:Concept {id: '7'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '2'}), (b:Concept {id: '8'}) CREATE (a)-[:CONTAINS]->(b);

// 机器学习概念包含知识点
MATCH (a:Concept {id: '6'}), (b:Detail {id: '16'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '6'}), (b:Detail {id: '17'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '7'}), (b:Detail {id: '18'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '8'}), (b:Detail {id: '19'}) CREATE (a)-[:CONTAINS]->(b);

// 深度学习章节包含概念
MATCH (a:Chapter {id: '3'}), (b:Concept {id: '9'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '3'}), (b:Concept {id: '10'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '3'}), (b:Concept {id: '11'}) CREATE (a)-[:CONTAINS]->(b);

// 深度学习概念包含知识点
MATCH (a:Concept {id: '9'}), (b:Detail {id: '20'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '9'}), (b:Detail {id: '21'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '10'}), (b:Detail {id: '22'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '11'}), (b:Detail {id: '23'}) CREATE (a)-[:CONTAINS]->(b);

// NLP章节包含概念
MATCH (a:Chapter {id: '4'}), (b:Concept {id: '12'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '4'}), (b:Concept {id: '13'}) CREATE (a)-[:CONTAINS]->(b);

// NLP概念包含知识点
MATCH (a:Concept {id: '12'}), (b:Detail {id: '24'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '12'}), (b:Detail {id: '25'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '12'}), (b:Detail {id: '26'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '13'}), (b:Detail {id: '27'}) CREATE (a)-[:CONTAINS]->(b);

// 计算机视觉章节包含概念
MATCH (a:Chapter {id: '5'}), (b:Concept {id: '14'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Chapter {id: '5'}), (b:Concept {id: '15'}) CREATE (a)-[:CONTAINS]->(b);

// 计算机视觉概念包含知识点
MATCH (a:Concept {id: '14'}), (b:Detail {id: '28'}) CREATE (a)-[:CONTAINS]->(b);
MATCH (a:Concept {id: '15'}), (b:Detail {id: '29'}) CREATE (a)-[:CONTAINS]->(b);

// ============================================
// 创建关系 - 前置依赖关系 (PREREQUISITE)
// ============================================

// 章节级别前置依赖
MATCH (a:Chapter {id: '2'}), (b:Chapter {id: '3'}) CREATE (a)-[:PREREQUISITE {description: '机器学习是深度学习的基础'}]->(b);
MATCH (a:Chapter {id: '3'}), (b:Chapter {id: '4'}) CREATE (a)-[:PREREQUISITE {description: '深度学习是NLP的基础'}]->(b);
MATCH (a:Chapter {id: '3'}), (b:Chapter {id: '5'}) CREATE (a)-[:PREREQUISITE {description: '深度学习是计算机视觉的基础'}]->(b);

// 概念级别前置依赖
MATCH (a:Concept {id: '9'}), (b:Concept {id: '10'}) CREATE (a)-[:PREREQUISITE {description: '神经网络是CNN的基础'}]->(b);
MATCH (a:Concept {id: '9'}), (b:Concept {id: '11'}) CREATE (a)-[:PREREQUISITE {description: '神经网络是RNN的基础'}]->(b);
MATCH (a:Concept {id: '11'}), (b:Concept {id: '12'}) CREATE (a)-[:PREREQUISITE {description: 'RNN是Transformer的前身'}]->(b);

// 知识点级别前置依赖
MATCH (a:Detail {id: '21'}), (b:Detail {id: '20'}) CREATE (a)-[:PREREQUISITE {description: '梯度下降是反向传播的基础'}]->(b);
MATCH (a:Detail {id: '24'}), (b:Detail {id: '25'}) CREATE (a)-[:PREREQUISITE {description: '注意力机制是BERT的核心'}]->(b);
MATCH (a:Detail {id: '24'}), (b:Detail {id: '26'}) CREATE (a)-[:PREREQUISITE {description: '注意力机制是GPT的核心'}]->(b);

// ============================================
// 创建关系 - 相关联关系 (RELATED_TO)
// ============================================

// 跨领域相关
MATCH (a:Concept {id: '10'}), (b:Concept {id: '14'}) CREATE (a)-[:RELATED_TO {description: 'CNN广泛用于目标检测'}]->(b);
MATCH (a:Concept {id: '10'}), (b:Concept {id: '15'}) CREATE (a)-[:RELATED_TO {description: 'CNN广泛用于图像分割'}]->(b);
MATCH (a:Concept {id: '11'}), (b:Concept {id: '12'}) CREATE (a)-[:RELATED_TO {description: 'RNN和Transformer都处理序列'}]->(b);

// 知识点相关
MATCH (a:Detail {id: '23'}), (b:Detail {id: '24'}) CREATE (a)-[:RELATED_TO {description: 'LSTM和注意力都解决长距离依赖'}]->(b);
MATCH (a:Detail {id: '25'}), (b:Detail {id: '26'}) CREATE (a)-[:RELATED_TO {description: 'BERT和GPT是互补的预训练方法'}]->(b);
MATCH (a:Detail {id: '22'}), (b:Detail {id: '28'}) CREATE (a)-[:RELATED_TO {description: 'ResNet是YOLO的骨干网络之一'}]->(b);
MATCH (a:Detail {id: '10'}), (b:Detail {id: '29'}) CREATE (a)-[:RELATED_TO {description: 'CNN是U-Net的基础架构'}]->(b);

// ============================================
// 常用查询示例
// ============================================

// 查询所有节点
// MATCH (n) RETURN n;

// 查询某个章节下的所有内容
// MATCH path = (c:Chapter {label: '深度学习'})-[:CONTAINS*]->(n) RETURN path;

// 查询某个知识点的前置依赖链
// MATCH path = (n)-[:PREREQUISITE*]->(target:Detail {label: 'BERT'}) RETURN path;

// 查询与某个概念相关的所有知识点
// MATCH (c:Concept {label: 'CNN'})-[:RELATED_TO|CONTAINS*]-(n) RETURN c, n;

// 查询学习路径（从机器学习到GPT）
// MATCH path = shortestPath((start:Chapter {label: '机器学习'})-[*]-(end:Detail {label: 'GPT'})) RETURN path;
