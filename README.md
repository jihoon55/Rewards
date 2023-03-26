# 김家네 Project
### 쇼핑몰 구매 고객 리워드 시스템

# 프로젝트 소개
### 유저는 사용자인증을 하고 출석, 조회, 수령 서비스를 이용 가능하며, 
### 관리자는 재고 부족 알림을 수신받을 수 있고 재고 조절, 현황 조회를 할 수 있는 출석 리워드 시스템입니다.

- 유저 정보 인증 후 하루 한번 출석 체크
- 일정 출석 횟수를 달성했을 때 해당하는 상품을 수령
> ex) 5 일 출석 -> 현금성 포인트 5000원 | 15 일 출석 -> 에어팟
- 이벤트 관리자가 출석 및 리워드 현황 체크 가능

# 개발기간
2023.03.07 ~ 2023.03.23

# 멤버구성
- 김상윤(조장) : 사용자 출석, 리워드 관리 ECS 서버 구축, ECS CI/CD 진행, 서버 IaC화 
- 김지훈 :
- 김건 : 
- 김태환 : 사용자 인증 시스템 중 Cognito 구현, 리워드 관리자 시스템 중 고객출석현황조회 리소스 구현

# 아키텍처 다이어그램

![image](https://user-images.githubusercontent.com/60168922/227113224-7c897ac1-d738-4d4c-8a5b-2924cb9d400c.png)


# 주요기능

### 데이터베이스 및 ERD 다이어그램

![image](https://user-images.githubusercontent.com/60168922/227113444-466c8c6a-ea9f-421a-9bb0-32397cde176b.png)


### 유저 정보 인증

![image](https://user-images.githubusercontent.com/60168922/227114056-e74a3df8-b4fa-4b03-8d11-b1c00c757c4a.png)
- 이미 사용자가 쇼핑몰 회원으로 등록 되어 있다
가정하고 토큰을 Cognito로부터 가져와 사용
- 이벤트 시스템의 root path에 들어왔을 때 토큰을
Cognito 로 보내 인증 진행
- 그 이후 유저 인증 여부를 boolean 값으로
저장해두고 출석 및 리워드 기능을 수행할 때 인증
여부 확인

### 유저 출석, 리워드 도메인

![image](https://user-images.githubusercontent.com/60168922/227114966-fed76633-486f-47c3-9a0b-578e390da95d.png)
- 출석관리, 받을 수 있는 리워드 확인, 리워드
수령 기능 제공
- VPC 외부에 있는 dynamoDB와 연동하기 위해
dynamoDB 용 VPC endpoint 사용
- 가용성 확보를 위해 Application Load Balancer와
Auto scaling group을 활용
- 서버리스 아키텍처를 구현을 위해 Fargate 사용

### 이벤트 관리자, 알림 도메인

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

### CI/CD (github actions, CodeBuild ..) & IaC (Terraform)

![image](https://user-images.githubusercontent.com/60168922/227115335-eecf1e75-6fac-40eb-9af8-41ce5c1552f1.png)
