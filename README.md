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

### 팀명 | 김家네 Project
### 개발기간 | 2023.03.07 ~ 2023.03.23
### 멤버구성
- 김상윤(조장) : 사용자 출석, 리워드 관리 ECS 서버 구축, ECS CI/CD 진행, 서버 IaC화 
- 김지훈 : 리워드 조회 및 재고 수량 조절, 이벤트 별 재고 확인 람다 서버 구축, DB구축, 람다 및 APIgateway, DB IaC화
- 김건 : 리워드 알림 서버리스 서버 및 SQS-DLQ 구현 및 IaC화
- 김태환 : 사용자 인증 시스템 중 Cognito 구현 및 IaC화, 관리자 시스템 중 고객출석현황조회 리소스 구현 

## 🌐 서비스 아키텍쳐
관리자 및 사용자의 리워드 시스템 Workflow
<details>
<summary>프로젝트 제출 아키텍처</summary>

![image](https://user-images.githubusercontent.com/60168922/227113224-7c897ac1-d738-4d4c-8a5b-2924cb9d400c.png)
</details>

<details>
<summary>개인 보완 아키텍처</summary>

<img src="https://user-images.githubusercontent.com/118710033/229508638-4e3dcf94-4935-4bb6-b6b3-b74be000104b.jpg" alt="png2pdf (1)_page-0001" width="600">

</details>


## 📌 서비스 구성  
<details>
<summary>데이터베이스 및 ERD 다이어그램</summary>

![image](https://user-images.githubusercontent.com/60168922/227113444-466c8c6a-ea9f-421a-9bb0-32397cde176b.png)
 

### AmazonDynamoDB
Amazon DynamoDB는 완전관리형 NoSQL 서버리스 데이터베이스 서비스입니다.
DynamoDB는 프로비저닝 및 온디맨드 용량 모드를 모두 제공하므로 테이블당 용량을 지정하거나 사용한 리소스에 대해서만 비용을 지불함으로써 비용을 최적화할 수 있습니다.
리워드 시스템 프로젝트에 필요한 서버들은 Lambda, Fagate 서버리스이며 Lambda와 DynamoDB는 모두 서버리스이기 때문에 인프라 관리 및 운영 비용을 크게 줄일 수 있습니다. 
서버리스 아키텍처에서는 인프라가 필요한 경우에만 비용이 발생하므로, 트래픽이 낮거나 트래픽의 피크 시간이 짧은 애플리케이션의 경우에는 람다와 다이나모디비의 조합이 매우 경제적인 장점이 있어 사용하게 되었습니다.
  
### Users 테이블
유저를 확인할 수 있는 id와 유저를 확인할 수 있게 username항목을, 유저가 사용할 수 있는 현금성 서비스를 확인하기 위해 user_point를, 해당 유저가 얼마나 출석을 했는지 확인할 수 있게 count를 넣었습니다.


### Attendance 테이블
출석을 확인할 수 있는 테이블로 출석을 확인할 수 있는 id를 넣고 유저별로 확인 할 수 있게 user_id를, 어떤 날에 출석을 확인했는지 확인하기 위해 date를 넣었습니다.
 

### Rewards 테이블
리워드를 확인 할 수 있는 id와 어떤 유저가 리워드를 받았는지 확인하기 위해 유저를 확인하는 user_id와 상품을 확인하는 product_id, 수령가능한 리워드의 필요한 출석 수를 확인하기 위해 reward_time을 넣었습니다
 

### Products 테이블
상품을 확인할 수 있는 id와 상품 이름을 등록한 name, 현재 보유중인 상태를 확인하기 위해 condition, 특정 개수를 유지 하기 위해 remain을 넣었습니다.
</details>

<details>
<summary>유저 정보 인증 </summary>

![image](https://user-images.githubusercontent.com/60168922/227114056-e74a3df8-b4fa-4b03-8d11-b1c00c757c4a.png)
코그니토 설명경도입배경

### Cognito
AWS Cognito를 사용하면 사용자 인증 및 권한 부여를 관리하는 데 필요한 작업을 단순화하고, 사용자 인증 및 권한 부여를 안전하고 쉽게 구현할 수 있습니다. 
  
  
애플리케이션에서 사용자 인증과 권한 부여를 구현하는 것이 복잡하고 보안에 민감하기 때문에 Cognito를 사용해 보안성을 높이고 사용자 데이터를 보호하기 위해 선택했습니다.

  
- 이미 사용자가 쇼핑몰 회원으로 등록 되어 있다 가정하고 토큰을 Cognito로부터 가져와 사용했습니다.
- 이벤트 시스템의 root path에 들어왔을 때 토큰을 Cognito로 보내 인증 진행했습니다.
- 그 이후 유저 인증 여부를 boolean 값으로 저장해두고 출석 및 리워드 기능을 수행할 때 인증 여부를 확인했습니다.
</details>


<details>
<summary>유저 출석, 리워드 도메인</summary>

![image](https://user-images.githubusercontent.com/60168922/227114966-fed76633-486f-47c3-9a0b-578e390da95d.png)

### ECS 클러스터
모든 서버가 컨테이너 환경 또는 서버리스로 구현되길 원하는 요구 사항을 바탕으로 ECS를 사용하였습니다.
  
  
ecs는 Multi AZ 기능과 auto scaling을 통한 높은 확장성 그리고 다른 컨테이너 오케스트레이션에 비해 간단한 구성과 운영이 가능하기 때문에 저희 서비스에 최적의 도구라고 생각하여 선택하게 되었습니다.
  
  
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

### Lambda
모든 서버가 컨테이너 환경 또는 서버리스로 구현되길 원하는 요구 사항을 바탕으로 Lambda를 사용하였습니다.
  
  
Lambda를 사용하면 서버 관리, 확장, 보안 등과 같은 작업을 서비스 제공업체(AWS)가 모두 처리해줌으로서, 서버 기반의 애플리케이션 개발 및 운영에 비해 시간과 비용을 크게 절약할 수 있게 해줍니다.
  
  
리워드 시스템 프로젝트에서는 소수의 관리자가 운영을 하기 떄문에 비용적으로 코드를 실행하고, 실행 시간에 따라 사용한 만큼만 비용을 지불하면 되어 선택하게 되었습니다.
 

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
- 출석관리, 받을 수 있는 리워드 확인, 리워드 수령 기능 제공
- VPC 외부에 있는 dynamoDB와 연동하기 위해 dynamoDB 용 VPC endpoint 사용
- 가용성 확보를 위해 AZ를 나누고 Application Load Balancer와 Auto scaling group을 활용
- 서버리스 아키텍처를 구현을 위해 Fargate 사용
</details>

## 💪 무엇을 배웠는가?
* Cognito를 이용해 사용자 인증을 구현할 수 있었습니다.
  * Cognito는 userpool, identitypool을 이용해 인증 인가를 할 수 있음
  * userpool을 이용해 토큰 인증 서비스를 구현함.
* DynamoDB에 대해 공부 할 수 있었음 - 좀 더 정리하기!!!
* VPC외부 서비스와 연결 방법에 대해 공부하여 VPCendpoint를 구현했습니다.
  * vpc엔드포인트에 대한 설명하기!!!
* Public, Private 서브넷에 통신 방법에 대해 정리 할 수 있었습니다.
  * baston: 인터넷을 통해 접속 가능한 공개 서브넷에 배치되며, Private Subnet의 리소스에 접근할 수 있도록 합니다.
  * natgateway: Private Subnet의 인스턴스가 인터넷을 통해 패킷을 보낼 수 있게 합니다.
* Eventbridge에 Cron Event생성 방법을 공부하고 Lambda에 트리거 시켰습니다.
* SES를 활용하여 Email을 전송 시스템을 구현할 수 있었습니다.
* SQS - SNS를 이용해 내결함성을 확보할 수 있었습니다.
  * 정리하기!!!
* Terraform을 통한 DynamoDB 생성 방법을 배웠습니다.


## 🚨 트러블 슈팅
###  문제 상황
Terraform을 이용해 APIgateway를 구현 완료 후 테스트 시 에러 발생

###  원인 파악
* 문제가 될 수 있는 부분을 먼저 추려보았습니다.
  * Terraform 리소스 부족
  * 권한 미부여
  * Lambda zip파일 오류
 
* Cloudwatch 확인 시 아무 응답도 없었습니다.
* Lambda만 테스트 해본 결과 람다는 정삭적으로 실행되며, Terraform apigateway의 리소스가 잘 못 됐다는것을 확인했습니다.
* 확인 결과 잘못된 리소스는 없었습니다.
* 콘솔에서 APIgateway를 확인해본 결과 estapi로 동작하고 있었으며, Lambda는 HTTP통신으로 동작하고 있었습니다.


### 문제 해결
* Terraform으로 apigateway를 만들경우 restapi가 기본값으로 생각했었습니다.
* 공식문서를 찾아본 결과 aws_apigatewayv2_api라는 HTTP 통신을 위한 리소스가 있는걸 확인했습니다.
* 테라폼 공식 문서 확인 결과 v2라는 HTTP통신을 위한 리소스를 확인
* aws_api_gateway_rest_api리소스를 aws_apigatewayv2_api리소스로 수정 후 정상적으로 실행되었습니다.


## 📋 블로깅 & 레퍼런스
* 블로깅

 
* 레퍼런스 
  * https://www.fastify.io/
  * https://github.com/fastify/fastify-cli
  * https://github.com/aws-actions/amazon-ecr-login
  * https://hub.docker.com/_/mongo
