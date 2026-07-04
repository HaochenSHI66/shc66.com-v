# OPTIMIZE_STATE

个人主页 (shc66.com) 高质量全量优化 loop 的状态文件。每轮迭代先读此文件,结束时更新。

## 项目事实
- 单文件架构:index.html(内联 CSS/JS,零依赖,无构建步骤)
- 部署:push 到 haochenshi66 remote (HaochenSHI66/shc66.com-v) master 分支自动上线 shc66.com
- 本机 git 凭据是旧号,push 需用 HaochenSHI66 PAT(见 memory)
- 验证手段:本地 `python3 -m http.server 8931` + Playwright 截图(桌面 1440 / 移动 390)+ 打印模拟 + pageerror 监听
- 硬规则:正文零 em-dash、零中点分隔链;锚点 ID (#about #research #projects #skills #contact) 不可变;不删服务器/仓库文件(先报告)

## 已完成

### Round 0(2026-07-04,重设计,commit 85a9e1d)
4 个设计 agent(UI/UX/前端/文案)+ taste-skill 审计 → 整页重写:
- 左对齐编辑部网格,hero 事实栏,出版物列表语法,项目索引表,深色 contact band
- 删 GSAP;IntersectionObserver + @starting-style;打印/无 JS 永远可见;自托管字体;WebP 图
- 修:BirdCLEF+ 命名 ×3、锚点双倍偏移、返回键 bug、死动画、CTA 倒挂
- 链接全部迁到 HaochenSHI66(旧号仓库全 404);PolyInterview GitHub 链接移除(仓库不存在)

### Round 1(2026-07-04,用户指定项:证书 + 字号)
- 新增 Kaggle Bronze 证书展示(assets/kaggle-bronze-certificate.webp, 39KB)于 CLEF 条目
- 全局字号 +12.5%(html font-size 112.5%,rem 等比缩放);section/entry 间距同步加大;h2 加大;图片加墨色柔影
- 排名统一为 263/4,094(以官方证书为准,与 CV 一致;原 262/4,085 出自论文快照)×3 处
- 验证:桌面/证书截图 OK,无 pageerror

## 待办(按维度)

### 正确性(下轮从这里扫)
- [ ] voca-memory 链接指向私有仓库,访客 404 —— 等用户设 public,或换链接
- [ ] CLEF 论文 PDF 内文写 262/4085 与页面 263/4,094 不一致(论文快照,页面已注明 awarded 数字;可接受,观察)
- [ ] learn/stock.shc66.com 返回 530(隧道未起);About 段落仍链着这两个域名 —— 隧道恢复后把项目行链接换回 demo,或提示用户起隧道

### 性能
- [ ] assets/avatar.png (1.3MB)、两张旧 PNG 框架图已无引用但仍随仓库部署 —— 删除需用户确认
- [ ] newsreader-var-latin.woff2 129KB(含全 opsz/wght 轴),可用 pyftsubset 裁剪到 ~40KB
- [ ] og:image 用的方形头像,可做 1200x630 专用卡

### 重复/可简化
- [ ] nav-links 和 btn-text 的下划线渐变 CSS 重复 3 处,可抽公共 class(收益小)

### 测试覆盖
- [ ] 把验证脚本固化:repo 内加 scripts/smoke.mjs(Playwright:标题/锚点/打印可见性/pageerror/死链检查),每轮跑

### 文档
- [ ] docs/superpowers/plans/2026-04-04-portfolio-redesign.md 已过时(描述的是上上版),可归档或删除(需确认)
- [ ] README 不存在,可写一份(架构/部署/验证方法)

## 下轮计划
Round 2:正确性维度扫描(死链全量 curl 校验 + HTML 结构校验),顺手做测试覆盖项(smoke 脚本固化),如无发现则做字体子集裁剪(性能)。
