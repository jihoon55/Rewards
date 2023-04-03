## ✨ 프로젝트 소개
쇼핑몰 구매 고객 리워드 시스템

* 유저는 사용자인증을 하고 출석, 조회, 수령 서비스를 이용 가능합니다 
* 관리자는 재고 부족 알림을 수신받을 수 있고 재고 조절, 현황 조회를 할 수 있는 출석 리워드 시스템입니다.
* 리워드 수령 방법
  - 유저 정보 인증 후 하루 한번 출석 체크
  - 일정 출석 횟수를 달성했을 때 해당하는 상품을 수령
  > ex) 5 일 출석 -> 현금성 포인트 5000원 | 15 일 출석 -> 에어팟
  - 이벤트 관리자가 출석 및 리워드 현황 체크 가능

## 👋 팀 소개

### 팀명| 김家네 Project
### 개발기간 | 2023.03.07 ~ 2023.03.23
### 멤버구성
- 김상윤(조장) : 사용자 출석, 리워드 관리 ECS 서버 구축, ECS CI/CD 진행, 서버 IaC화 
- 김지훈 : 
- 김건 : 
- 김태환 : 사용자 인증 시스템 중 Cognito 구현, 리워드 관리자 시스템 중 고객출석현황조회 리소스 구현

## 🌐 서비스 아키텍쳐
관리자 및 사용자의 리워드 시스템 사용 데이
![image](https://user-images.githubusercontent.com/60168922/227113224-7c897ac1-d738-4d4c-8a5b-2924cb9d400c.png)


## 📌 서비스 구성  
<details>
<summary>데이터베이스 및 ERD 다이어그램</summary>
![image](https://user-images.githubusercontent.com/60168922/227113444-466c8c6a-ea9f-421a-9bb0-32397cde176b.png)
테이블 설명 간단히
</details>

<details>
<summary>유저 정보 인증</summary>
![image](https://user-images.githubusercontent.com/60168922/227113444-466c8c6a-ea9f-421a-9bb0-32397cde176b.png)
- 이미 사용자가 쇼핑몰 회원으로 등록 되어 있다
가정하고 토큰을 Cognito로부터 가져와 사용
- 이벤트 시스템의 root path에 들어왔을 때 토큰을
Cognito 로 보내 인증 진행
- 그 이후 유저 인증 여부를 boolean 값으로
저장해두고 출석 및 리워드 기능을 수행할 때 인증
여부 확인
</details>


<details>
<summary>유저 출석, 리워드 도메인</summary>
![image](https://user-images.githubusercontent.com/60168922/227114966-fed76633-486f-47c3-9a0b-578e390da95d.png)
- 출석관리, 받을 수 있는 리워드 확인, 리워드
수령 기능 제공
- VPC 외부에 있는 dynamoDB와 연동하기 위해
dynamoDB 용 VPC endpoint 사용
- 가용성 확보를 위해 Application Load Balancer와
Auto scaling group을 활용
- 서버리스 아키텍처를 구현을 위해 Fargate 사용
</details>

<details>
<summary>이벤트 관리자, 알림 도메인</summary>
![image](https://user-images.githubusercontent.com/60168922/227115098-8a9b47ae-807f-4324-b907-96dc47ae2451.png)
#### 관리자 도메인
- 상품 재고 관리 , 리워드 출석 현황 관리 기능
제공
- 서버리스 아키텍처 구현을 위해 Lambda 사용
#### 재고 확인 알림 도메인
- Event Bridge의 cron기능을 활용해 매일
주기적으로 재고 조회
- AWS SES 서비스를 활용해 관리자에게 알림
메일을 보냄
- 추가적으로 유저 API 에서 상품 수령 후 재고
부족할 시 알림 메일 생성
</details>

<details>
<summary>CI/CD (github actions, CodeBuild ..) & IaC (Terraform)</summary>
![image](https://user-images.githubusercontent.com/60168922/227115335-eecf1e75-6fac-40eb-9af8-41ce5c1552f1.png)
- 출석관리, 받을 수 있는 리워드 확인, 리워드
수령 기능 제공
- VPC 외부에 있는 dynamoDB와 연동하기 위해
dynamoDB 용 VPC endpoint 사용
- 가용성 확보를 위해 Application Load Balancer와
Auto scaling group을 활용
- 서버리스 아키텍처를 구현을 위해 Fargate 사용
</details>

## 💪 무엇을 배웠는가?
* fastiy 프레임워크를 이용한 컨테이너 배포 방법을 알게됐습니다.
  * fastify 서버를 시작하면 로컬호스트 주소로 동작하므로 AWS에 컨테이너를 띄워도 접속할 수 없다. 따라서, package.json에서 -a 옵션으로 0.0.0.0 주소로 시작할 수 있도록 해야한다.
* GitHub Action을 이용한 ECS 자동화 동작 원리를 알고, Json파일을 이용한 CI/CD를 알 수 있었습니다.
  * ECR, ECS Workflow파일에 대해 공부할 수 있었음.
* AWS Secrets Manager을 이용한 데이터베이스 Task Definition에 환경변수를 설정할 수 있었습니다.
  * AWS Secrets Manager를 사용하기 위해서는 ECS역할에 Secrets Manager ReadWrite정책을 추가해줘야 사용할 수 있음.
* ECS 배포 시 새로운 이미지가 배포되지 않는 오류가 트러블 슈팅
  * 배포가 완료되도 성곡적인 배포가 아니기 때문에 완료된 부분이라도 배재하지 말고 트래픽의 흐림을 순차적으로 생각하게됨.
  * 오류가 나타나지 않아도 실행되는 서비스에 로그를 확인해야 되는것을 알게 됨.

## 🚨 트러블 슈팅
* 문제 상황
GitHub Action사용 시 ECS 배포는 정삭적으로 작동하지만 실행 시간이 26분이었으며, 배포 된 이미지는 새로운 이미지가 아닌 기존에 이미지가 배포된 상태였다.

* 원인 파악
문제가 될 수 있는 부분을 먼저 추려보았다
 - 깃허브 액션
 - 클러스터 서비스 설정
 - task definition

먼저 배포가 정상적으로 됐기 때문에 GitHub Action Workflow에서는 문제가 없다 판단했다.

그 후 클러스터 서비스와 Task Definition를 재설정하지만 똑같이 배포 시간과 오류가 발생하고 있었다

 
 여기서 실수가 테스크, 서비스 로그를 확인했어야 했지만 다른 방법으로 오류를 찾아 나섰다 만약 이때 로그를 확인했으면 더 빠른 방법으로 오류를 찾을 수 있었다(캡쳐한 로그 기록이 없다..)
2. 배포가 됐다고 다른 배재하고 다른 문제를 찾는게 아니라 순차적으로 과정을 생각하자 결국 ecr에서 ecs로 가는 과정 즉 워크플로우에서 설정 내용이 문제인 것 처럼
처음부터 모든 설정을 확인했지만 크게 잘 못 설정된 부분은 없었다

* 문제 해결
처음부터 트래픽에 흐름에 맞게 순차적으로 확인해 보니 Workflow파일에 ECR_Registry가 정답이지만 내 파일에는 Registry만 적혀져 있었습니다.
Workflow 내용을 공부하면서 직접 작성했던것이 에러를 만들었던 원인이 었고 ECR_Registry로 수정 후 3분 이내로 새로운 이미지가 배포되었습니다.


## 📋 블로깅 & 레퍼런스
* 블로깅
  * https://jihoon555.tistory.com/58
  * https://jihoon555.tistory.com/59
 
* 레퍼런스 
  * https://www.fastify.io/
  * https://github.com/fastify/fastify-cli
  * https://github.com/aws-actions/amazon-ecr-login
  * https://hub.docker.com/_/mongo
