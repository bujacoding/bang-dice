## git commit

git status # 현재 상태 확인

git add . # 현재 폴더의 변경 사항 stage area 로 보내기

git commit # 커밋

## git push

git branch # 현재 브랜치가 무엇인지 확인

git push origin <branch> # <branch>를 origin 으로 푸쉬함.

#### 추가 예제
```
git push origin june 
# origin 이라는 리모트 저장소에 로컬의 june 브랜치를 리모트의 june 브랜치로 푸쉬한다.

git push origin june:june 
# origin 이라는 리모트 저장소에 로컬의 june 브랜치를 리모트의 june 브랜치로 푸쉬한다.

git push origin june:june1 
# origin 이라는 리모트 저장소에 로컬의 june 브랜치를 리모트의 june1 브랜치로 푸쉬한다.
```

## git fetch & merge
git fetch origin # origin 으로부터 모든 브랜치 받아오기

git merge origin/<branch> # origin/branch 를 현재 브랜치로 합치기