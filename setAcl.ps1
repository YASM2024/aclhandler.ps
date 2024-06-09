########################################################################
#
#�@�t�H���_�����ݒ�p�X�N���v�g
#  �R�}���h���C���Ŏg�p����B
#�@��jpowershell setAcl.ps1 $targetPath $domain $userIntegratedIDs
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
    if($mkdir){echo "�t�H���_�����݂��Ȃ��������ߐV�K�ɍ쐬���܂����B"}
    echo "�t�H���_�����ݒ芮�����܂����B"
    echo "�Ώۃt�H���_�F" $targetPath
    echo "�ΏێҁF" $userIntegratedIDs

} catch {

    echo $now
    echo "�t�H���_�����ݒ�Ɏ��s���܂����B"

}