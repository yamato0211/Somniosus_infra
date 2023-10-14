# ADR (Architectural Decision Record) for terraform

## IaCツールの技術選定

### 背景
長期的な運用・保守まで目を向けると、IaC化を図ることは有効な手段の一つとなる。
- 開発が安定しているか(バージョン等)
- 主なクラウドに対応しているか(AWS,GCP)

### 決定
terraformを使用する。
### 理由
- 運用のしやすさ
    - IaCにより、リソースの把握・変更が容易である
    - namespaceを活用した、ステージング環境の実現
- プラン
    - terraform planで変更点の可視化が行える。
- ドキュメント
    - ドキュメントが充実している。
- ファイル分割
    - ファイル分割が容易である。
### 代替案
- CloudFormation
    - 使用するクラウドがAWSだったので、代替案として挙げる。
    - マルチクラウドが難しい
    - ファイル分割が難しく、加毒性が下がる可能性
    - コードのバリデーションがterraformのほうが充実している。
### 影響

### 参考情報
[CloudFormation vs Terraform](https://qiita.com/answer_d/items/74c3d317058d48394d21)
執筆日：2023/10/14 14:20
