#!/bin/sh

#打印错误信息
errorMessage()
{
    echo  "\033[41;37m $1 \033[0m"
}

#打印操作成功信息
niceMessage()
{
    echo -e "\033[42;37m $1 \033[0m"
}

#打印警告信息
warnMessage()
{
    echo -e "\033[43;37m $1 \033[0m"
}

#验证上一步操作是否正确
verifyOperation()
{
    EXCODE=$?
    if [ "$EXCODE" != "0" ]; then
        errorMessage $1
        exit 1
    fi

    niceMessage $2
}


#生成新的版本号
createNewVersion()
{
    #提取版本号后缀
    suffix=`echo $1 | cut -d "." -f4`
    ((suffix++))
    newVersion=""
    for k in {1..3}
        do
            num=`echo $1 | cut -d "." -f$k`
            newVersion=$newVersion$num.
        done
    echo $newVersion$suffix
}

updateVersion()
{
    #提取代码版本所在行
    git pull origin master
    versionLine=`cat $1.podspec |grep -E 's.version(.*)='`

    #提取当前版本号
    version=`echo $versionLine | cut -d "\"" -f2`

    #生成新版本号
    newVersion=`createNewVersion $version`
    niceMessage "$1 oldVersion = $version, newVersion = $newVersion"

    #替换新的版本号
    sed -i ' ' "s/$versionLine/s.version      = \"$newVersion\"/g" ./$1.podspec
    rm ./$1.podspec\

    echo $newVersion
}

#编译.a文件
./buildReact.sh Debug Yoga
verifyOperation " build Debug Yoga 失败 " " build Debug Yoga 成功 " 

./buildReact.sh Release Yoga
verifyOperation " build Release Yoga 失败 " " build Release Yoga 成功 " 

./buildReact.sh Debug React
verifyOperation " build Debug React 失败 " " build Debug React 成功 " 

./buildReact.sh Release React
verifyOperation " build Release React 失败 " " build Release React 成功 " 

#更新版本号
updateVersion Yoga
newVersion=`updateVersion Yoga_debug`

#先验证Yoga的podspec
#pod lib lint --allow-warnings --use-libraries  --sources=https://github.com/dennis-li/DennisRepos.git
#verifyOperation " pod lib lint 出错！请检查podspec！！"

#将改动推到远程仓库并创建新的分支
git add .
git commit -m "auto create new branch"
git tag -a $newVersion -m  "React v$newVersion"
git push origin master
verifyOperation "React创建新的tag => $newVersion 失败!!!"
git push origin $newVersion
verifyOperation "React 创建新的tag => $newVersion 失败!!!"

#更新私有库
pod repo update DennisRepos
verifyOperation "更新私有pod库失败!!!" "更新私有pod库成功!!!"

#先更新Yoga
pod repo push DennisRepos Yoga.podspec --verbose --use-libraries --allow-warnings
pod repo push DennisRepos Yoga_debug.podspec --verbose --use-libraries --allow-warnings
verifyOperation "更新Yoga私有库信息失败" "更新私有库信息成功"

#验证React的podspec
pod lib lint --allow-warnings --use-libraries  --sources=https://github.com/dennis-li/DennisRepos.git
verifyOperation " pod lib lint 出错！请检查podspec！！"

#更新React
pod repo push DennisRepos React.podspec --verbose --use-libraries --allow-warnings
pod repo push DennisRepos React_debug.podspec --verbose --use-libraries --allow-warnings
verifyOperation "更新Yoga私有库信息失败" "更新私有库信息成功"

niceMessage "更新React  pod 成功！！！"







