########################################################################
#
#　フォルダ権限設定用スクリプト
#  コマンドラインで使用する。
#　例）powershell setAcl.ps1 $targetPath $domain $userIntegratedIDs
#
########################################################################

$now = Get-Date

try{

    $targetPath = $args[0] #"C:Path\to\folder"
    $domain = $args[1]     #"DOMAIN"
    $userIntegratedIDs = $args[2..($args.Length - 1)]#USERNAME1, USERNAME2, USERNAME3 ...

    if((Test-Path "$targetPath") -eq "False"){ 
        $mkdir = $true
        mkdir "$targetPath"
    }

    $rights = "Modify, ReadAndExecute"
    $inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $propagation = [System.Security.AccessControl.PropagationFlags]::None
    $type = [System.Security.AccessControl.AccessControlType]::Allow

    foreach ($userIntegratedID in $userIntegratedIDs){
        $permission = $domain + "\" + $userIntegratedID
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission, $rights, $inheritance, $propagation, $type)
        $acl = Get-Acl "$targetPath"
        $acl.SetAccessRule($accessRule)
        Set-Acl "$targetPath" $acl
    }

    echo $now
    if($mkdir){echo "フォルダが存在しなかったため新規に作成しました。"}
    echo "フォルダ権限設定完了しました。"
    echo "対象フォルダ：" $targetPath
    echo "対象者：" $userIntegratedIDs

} catch {

    echo $now
    echo "フォルダ権限設定に失敗しました。"

}