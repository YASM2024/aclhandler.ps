########################################################################
#
#　フォルダ権限削除用スクリプト
#  コマンドラインで使用する。
#　例）powershell rmAcl.ps1 $targetPath $domain $userIntegratedIDs
#
########################################################################

$now = Get-Date

try {

    $targetPath = $args[0] # "C:\Path\to\folder"
    $domain = $args[1]     # "DOMAIN"
    $userIntegratedIDs = $args[2..($args.Length - 1)] # USERNAME1, USERNAME2, USERNAME3 ...

    if ((Test-Path "$targetPath") -eq $false) {
        echo "指定されたパスが存在しません。"
        exit
    }

    foreach ($userIntegratedID in $userIntegratedIDs) {
        $permission = $domain + "\" + $userIntegratedID
        $acl = Get-Acl "$targetPath"
        $accessRule = $acl.Access | Where-Object { $_.IdentityReference -eq $permission }
        if ($accessRule -ne $null) {
            foreach ($rule in $accessRule) {
                $acl.RemoveAccessRule($rule)
                Set-Acl "$targetPath" $acl
            }
        }
    }

    echo $now
    echo "フォルダ権限の削除が完了しました。"
    echo "対象フォルダ：" $targetPath
    echo "対象者：" $userIntegratedIDs

} catch {

    echo $now
    echo "フォルダ権限の削除に失敗しました。"

}
