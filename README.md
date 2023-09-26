# AWS-CDK GitHub Actions

AWS-CDK GitHub Actions enables the execution of various CDK subcommands, such as `cdk deploy` and `cdk diff`, on your pull requests for an improved review experience.

## Supported Languages

- TypeScript
- JavaScript
- Python
- Golang

## Example Usage

```yaml
on: [push]

jobs:
  aws_cdk:
    runs-on: ubuntu-latest
    steps:

      - name: cdk diff
        uses: mldangelo/aws-cdk-github-actions@main
        with:
          cdk_subcommand: 'diff'
          actions_comment: true
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'ap-northeast-1'

      - name: cdk deploy
        uses: mldangelo/aws-cdk-github-actions@main
        with:
          cdk_subcommand: 'deploy'
          cdk_stack: 'stack1'
          cdk_args: '--require-approval never'
          actions_comment: false
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'ap-northeast-1'

      - name: cdk synth
        uses: mldangelo/aws-cdk-github-actions@main
        with:
          cdk_subcommand: 'synth'
          cdk_version: '1.16.2'
          node_version: '18'
          working_dir: 'src'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'ap-northeast-1'
```

### Using Assume-Role

For those utilizing assume-role, we recommend [awscredswrap](https://github.com/marketplace/actions/aws-assume-role-github-actions).

See: [aws-assume-role-github-actions documentation](https://github.com/marketplace/actions/aws-assume-role-github-actions#use-as-github-actions)

```yaml
on: [push]

jobs:
  aws_cdk:
    runs-on: ubuntu-latest
    steps:
      - name: Assume Role
        uses: youyo/awscredswrap@master
        with:
          role_arn: ${{ secrets.ROLE_ARN }}
          duration_seconds: 3600
          role_session_name: 'awscredswrap@GitHubActions'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'ap-northeast-1'

      - name: cdk diff
        uses: mldangelo/aws-cdk-github-actions@main
        with:
          cdk_subcommand: 'diff'
```

## Inputs

- `cdk_subcommand` **Required** AWS CDK subcommand to execute ('deploy', 'diff', etc.)
- `actions_comment` Decide if you want to comment on pull requests. Default: true
- `cdk_stack` AWS CDK stack name to execute. Default: '*'
- `cdk_version` Version of AWS CDK to install. Default: 'latest'
- `debug_log` Enable debug logging? Default: false
- `node_version` Version of Node.js to use. Default: '18'
- `working_dir` AWS CDK working directory. Default: '.'

## Outputs

- `status_code` The status code returned by the CDK command.

## ENV

- `AWS_ACCESS_KEY_ID` **Required**
- `AWS_SECRET_ACCESS_KEY` **Required**
- `GITHUB_TOKEN` Necessary when `actions_comment=true`

For security, we recommend sourcing `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` from your repository's secrets. GitHub automatically provides a token as a secret named `GITHUB_TOKEN`.

## License

[MIT](LICENSE)

## Authors

- Original work by [youyo](https://github.com/youyo)
- Modifications by [Michael D'Angelo](https://github.com/mldangelo)
