# AWS-CDK GitHub Actions

The AWS-CDK GitHub Actions facilitates the execution of various CDK subcommands, such as `cdk deploy` and `cdk diff`, within your pull requests to enhance the review experience.

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

For those employing assume-role, [awscredswrap](https://github.com/marketplace/actions/aws-assume-role-github-actions) is recommended.

Refer to the [aws-assume-role-github-actions documentation](https://github.com/marketplace/actions/aws-assume-role-github-actions#use-as-github-actions) for more details.

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

- `cdk_subcommand` **Required** The AWS CDK subcommand to execute (e.g., 'deploy', 'diff').
- `actions_comment` Decide if comments should be posted on pull requests. Default: 'true'.
- `cdk_stack` The AWS CDK stack name for execution. Default: '*'.
- `cdk_version` The version of AWS CDK to install. Default: 'latest'.
- `debug_log` Enable detailed logging? Default: 'false'.
- `node_version` Specify the Node.js version. Default: '18'.
- `working_dir` The working directory for AWS CDK. Default: '.'.

## Outputs

- `status_code` The status code returned by the executed CDK command.

## Environment Variables

- `AWS_ACCESS_KEY_ID` **Required**
- `AWS_SECRET_ACCESS_KEY` **Required**
- `GITHUB_TOKEN` Required when `actions_comment=true`

For security reasons, we recommend sourcing the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` values from your repository's secrets. GitHub automatically provides a `GITHUB_TOKEN` as a secret.

## License

[MIT](LICENSE)

## Authors

- Originally developed by [youyo](https://github.com/youyo)
- Updated by [Michael D'Angelo](https://github.com/mldangelo)
