# 知识图谱可视化系统

一个基于Neo4j的知识图谱可视化平台，支持政治理论知识的图谱展示、搜索和智能问答。

## 功能特性

### 📊 知识图谱可视化
- 基于vis.js的交互式图谱展示
- 支持节点拖拽、缩放、平移
- 实时显示节点和关系统计信息
- 自适应屏幕布局

### 🔍 智能搜索
- 节点关键词搜索
- 实时搜索结果展示
- 点击搜索结果快速定位节点

### 🤖 AI问答系统
- 基于DeepSeek API的智能问答
- 自动生成Cypher查询语句
- 自然语言查询知识图谱

### ✏️ 节点管理
- 查看节点详细信息
- 编辑节点属性
- 删除节点操作

## 技术栈

- **前端**: HTML5, Tailwind CSS, vis.js
- **后端**: Python Flask
- **数据库**: Neo4j
- **AI服务**: DeepSeek API

## 快速开始

### 环境要求
- Python 3.8+
- Neo4j 数据库
- DeepSeek API Key

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd graph-chat
```

2. 安装依赖
```bash
pip install -r requirements.txt
```

3. 配置环境变量
```bash
export DEEPSEEK_API_KEY="your-api-key"
export NEO4J_URI="bolt://localhost:7687"
export NEO4J_USER="neo4j"
export NEO4J_PASSWORD="your-password"
```

4. 初始化数据库
```bash
# 导入政治理论知识图谱数据
cypher-shell -u neo4j -p your-password < politics_data.cypher
```

5. 启动应用
```bash
python app.py
```

6. 访问应用
打开浏览器访问: http://localhost:5000

## 项目结构

```
graph-chat/
├── app.py                 # Flask主应用
├── neo4j_db.py           # Neo4j数据库操作
├── deepseek_qa.py        # DeepSeek问答服务
├── politics_data.cypher  # 政治理论知识图谱数据
├── templates/
│   └── index.html        # 前端页面
├── requirements.txt      # Python依赖
└── README.md            # 项目说明
```

## 使用说明

### 知识图谱浏览
1. 页面加载后自动显示知识图谱
2. 可以拖拽节点调整位置
3. 使用"适应展示"按钮重置视图
4. 点击节点查看详细信息

### 搜索功能
1. 在搜索框输入关键词
2. 点击搜索按钮或按Enter键
3. 在右侧查看搜索结果
4. 点击结果项定位到对应节点

### AI问答
1. 在问答框输入问题
2. 点击提问按钮或按Enter键
3. 查看AI生成的答案和Cypher查询

### 节点编辑
1. 点击节点查看详情
2. 点击"编辑"按钮修改信息
3. 点击"删除"按钮删除节点

## 数据模型

### 节点类型
- **Theory**: 政治理论 (马克思主义、毛泽东思想、邓小平理论等)
- **Concept**: 核心概念 (辩证唯物主义、改革开放等)
- **Practice**: 实践活动 (新民主主义革命、改革开放等)

### 关系类型
- **DEVELOPS_INTO**: 理论发展关系
- **CONTAINS**: 理论包含概念
- **GUIDES**: 理论指导实践
- **REFLECTS**: 实践反映理论

## API接口

### 图谱数据
- `GET /api/real_graph_data` - 获取真实图谱数据
- `GET /api/graph_data` - 获取模拟图谱数据

### 节点操作
- `GET /api/node/<node_id>` - 获取节点详情
- `POST /api/update_node/<node_id>` - 更新节点信息
- `DELETE /api/delete_node/<node_id>` - 删除节点

### 搜索和问答
- `GET /api/search?q=<keyword>` - 搜索节点
- `GET /api/qa?question=<question>` - AI问答

## 开发说明

### 添加新功能
1. 后端API在`app.py`中添加路由
2. 前端交互在`templates/index.html`中实现
3. 数据库操作在`neo4j_db.py`中扩展

### 自定义样式
- 使用Tailwind CSS类名
- 主要样式在`templates/index.html`中定义

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request来改进项目。
