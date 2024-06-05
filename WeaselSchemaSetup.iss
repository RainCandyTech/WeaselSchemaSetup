#define AppId "{CFC336F3-B7AA-4064-9188-657B54B2B0EB}"
#define AppName "小狼毫配置方案"
#define AppExeName "小狼毫配置方案"
#define AppVersion "2.0.0.0"
#define AppPublisher "YukiIsait"
#define AppCopyright "Copyright (C) 2024 YukiIsait"

[Setup]
AppId={{#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName}
AppPublisher={#AppPublisher}
AppCopyright={#AppCopyright}
VersionInfoVersion={#AppVersion}
VersionInfoDescription={#AppName}
OutputBaseFilename={#AppExeName}
PrivilegesRequired=admin
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
Uninstallable=no
DisableDirPage=yes
UsePreviousAppDir=no
DisableWelcomePage=false
AlwaysShowDirOnReadyPage=yes
LicenseFile=Resources\License.rtf
SetupIconFile=Resources\Icon.ico
WizardImageFile=Resources\WizardImage.bmp
WizardSmallImageFile=Resources\WizardSmallImage.bmp
DefaultDirName={code:GetDefaultDirName}

[Languages]
Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Messages]
chinese.ClickNext=点击“下一步”继续，或点击“取消”退出安装程序。%n%n%n%n雨糖科技 荣誉制作 | 大鸣大放 年轻绚烂

[Types]
Name: "full"; Description: "全部安装"
Name: "custom"; Description: "自定义安装"; Flags: iscustom

[Components]
; 通用配置
Name: "Common"; Description: "通用配置"; Types: full custom; Flags: fixed
; 拼音方案配置
Name: "RimeIce"; Description: "雾凇拼音"; Types: full
Name: "RimeIce\FullPinyin"; Description: "全拼方案"; Flags: exclusive
Name: "RimeIce\DoublePinyinNC"; Description: "双拼方案-自然码"; Flags: exclusive
Name: "RimeIce\DoublePinyinABC"; Description: "双拼方案-智能ABC"; Flags: exclusive
Name: "RimeIce\DoublePinyinFLY"; Description: "双拼方案-小鹤"; Flags: exclusive
Name: "RimeIce\DoublePinyinMS"; Description: "双拼方案-微软"; Flags: exclusive
Name: "RimeIce\DoublePinyinSG"; Description: "双拼方案-搜狗"; Flags: exclusive
Name: "RimeIce\DoublePinyinZG"; Description: "双拼方案-紫光"; Flags: exclusive
; 五笔方案配置
Name: "RimeWubi"; Description: "空山五笔"; Types: full
Name: "RimeWubi\86"; Description: "86方案"; Flags: exclusive
Name: "RimeWubi\98"; Description: "98方案"; Flags: exclusive
Name: "RimeWubi\06"; Description: "新世纪方案"; Flags: exclusive

[Files]
; 通用配置
Source: "Schemas\Common\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: Common
Source: "Customs\Common\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: Common
; 拼音方案配置
Source: "Schemas\RimeIce\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce
Source: "Customs\RimeIce\*"; DestDir: "{app}"; Excludes: "rime.lua"; Flags: ignoreversion recursesubdirs; Components: RimeIce
Source: "Customs\RimeIceFullPinyin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\FullPinyin
Source: "Customs\RimeIceDoublePinyinNC\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinNC
Source: "Customs\RimeIceDoublePinyinABC\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinABC
Source: "Customs\RimeIceDoublePinyinFLY\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinFLY
Source: "Customs\RimeIceDoublePinyinMS\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinMS
Source: "Customs\RimeIceDoublePinyinSG\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinSG
Source: "Customs\RimeIceDoublePinyinZG\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeIce\DoublePinyinZG
; 五笔方案配置
Source: "Schemas\RimeWubi\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeWubi
Source: "Customs\RimeWubi\*"; DestDir: "{app}"; Excludes: "rime.lua"; Flags: ignoreversion recursesubdirs; Components: RimeWubi
Source: "Schemas\RimeWubiTables86\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeWubi\86
Source: "Schemas\RimeWubiTables98\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeWubi\98
Source: "Schemas\RimeWubiTables06\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs; Components: RimeWubi\06
Source: "Fonts\黑体字根.ttf"; DestDir: "{commonfonts}"; FontInstall: "黑体字根"; Flags: onlyifdoesntexist uninsneveruninstall; Components: RimeWubi
; RimeLua文件
Source: "Customs\RimeWubi\rime.lua"; DestDir: "{tmp}"; DestName: "rime_wubi.lua"; Flags: ignoreversion; Components: RimeWubi
Source: "Customs\RimeIce\rime.lua"; DestDir: "{tmp}"; DestName: "rime_ice.lua"; Flags: ignoreversion; Components: RimeIce

[Run]
; 混合RimeLua文件
Filename: "{cmd}"; Parameters: "/c copy /y /b ""{tmp}\rime_wubi.lua""+""{tmp}\rime_ice.lua"" ""{app}\rime.lua"""; Flags: runhidden; Components: RimeWubi
Filename: "{cmd}"; Parameters: "/c copy /y /b ""{tmp}\rime_ice.lua""+""{tmp}\rime_wubi.lua"" ""{app}\rime.lua"""; Flags: runhidden; Components: RimeIce
; 部署
Filename: "{code:GetWeaselDirName}\WeaselServer.exe"; Flags: runhidden nowait
Filename: "{code:GetWeaselDirName}\WeaselDeployer.exe"; Description: "启动部署程序"; Parameters: "/install"; Flags: postinstall nowait skipifsilent

[Code]
function GetDefaultDirName(Param: String): String;
var
    RimeUserDir: String;
begin
    Result := ExpandConstant('{userappdata}\Rime');
    if RegQueryStringValue(HKCU, 'Software\Rime\Weasel', 'RimeUserDir', RimeUserDir) then
        if RimeUserDir <> '' then
            Result := RimeUserDir;
end;

function GetWeaselDirName(Param: String): String;
var
    WeaselRoot: String;
begin
    Result := ''
    if RegQueryStringValue(HKLM32, 'Software\Rime\Weasel', 'WeaselRoot', WeaselRoot) then
        if WeaselRoot <> '' then
            Result := WeaselRoot;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
    WeaselRoot: String;
    AppDir: String;
    ErrorCode: Integer;
begin
    WeaselRoot := GetWeaselDirName('');
    if WeaselRoot <> '' then
    begin
        AppDir := ExpandConstant('{app}');
        if DirExists(AppDir) then
            if ShellExec('', WeaselRoot + '\WeaselServer.exe', '/q', '', SW_SHOW, ewWaitUntilTerminated, ErrorCode) then
                if SuppressibleMsgBox('是否进行全新安装？这将删除现有的用户配置。', mbConfirmation, MB_YESNO, IDNO) = IDYES then
                    if DelTree(AppDir + '\*', False, True, True) then
                        Result := ''
                    else
                        Result := '删除用户配置失败。'
                else
                    Result := ''
            else
                Result := '退出小狼毫算法服务失败。'
        else
            Result := '未找到用户目录，请检查是否正确安装小狼毫输入法。'
    end
    else
        Result := '未找到程序目录，请检查是否正确安装小狼毫输入法。';
end;
