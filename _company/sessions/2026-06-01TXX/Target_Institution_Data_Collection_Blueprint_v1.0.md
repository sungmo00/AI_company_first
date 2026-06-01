# Target Institution Data Collection Blueprint v1.0 (For Developer)

## 🎯 목표
정부 및 공공기관의 연구과제 데이터를 안정적이고 효율적으로 수집하기 위한 타겟 기관별 접근 경로, 데이터 요구사항(Schema), 및 초기 모듈 설계 정보를 제공합니다.

## ⚙️ 개요
본 문서는 Researcher가 검토한 최우선 타겟 기관별 데이터 수집 전략의 최종 청사진입니다. Developer는 이 문서를 기반으로 PostgreSQL DB 스키마 확정 및 데이터 수집 모듈(API/크롤링)의 초기 템플릿 설계를 즉시 착수해야 합니다.

## 🏛️ 타겟 기관별 상세 전략 (Top 5)

| ID | 기관명 (Target) | 접근 경로 유형 (API/Web/Scrape) | URL/Endpoint 초안 | 데이터 수집 난이도 (1-5, 5=최고) | 안정성 평가 (Risk Score) | 핵심 데이터 필드 매핑 (Schema Key) | AMS 가중치 초안 |
| :---: | :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| 1 | [기관명 A] | [예: API 호출 (OAuth 필요)] | [초안 URL/Endpoint] | [1-5] | [High/Med/Low] | `project_name`, `funding_source`, `submission_date` | High (30%) |
| 2 | [기관명 B] | [예: 웹 크롤링 (JavaScript 필요)] | [초안 URL] | [1-5] | [High/Med/Low] | `project_title`, `keywords`, `status` | Medium (20%) |
| 3 | [기관명 C] | [예: 내부 시스템 접근 (Manual)] | N/A (인증 필요) | 5 | Very High | `project_id`, `researcher_name` | High (30%) |
| 4 | [기관명 D] | [예: 공개 데이터 포털 (CSV)] | [초안 URL] | [1-5] | [High/Med/Low] | `project_name`, `budget` | Low (10%) |
| 5 | [기관명 E] | [예: RSS 피드 수집] | [초안 URL] | [1-5] | [High/Med/Low] | `project_title`, `publication_date` | Medium (20%) |

---

## 📝 데이터 요구사항 상세 (Schema Mapping)

Developer는 아래 정의된 최소 필수 컬럼을 기준으로 PostgreSQL DB 스키마를 설계해야 합니다.

| 데이터 항목 (Researcher 정의) | 설명 | 필수 여부 | 관련 기관 매핑 예시 | AMS 가중치 반영 |
| :--- | :--- | :---: | :--- | :--- |
| `project_id` | 고유 식별자 | 필수 | 모든 기관 (필수) | N/A |
| `project_name` | 연구과제명 | 필수 | A, B, C | High (30%) |
| `funding_source` | 자금 지원처 | 필수 | A, D | High (25%) |
| `submission_date` | 제안서 제출일 | 선택 | A, B | Medium (15%) |
| `keywords` | 주요 연구 키워드 | 선택 | B, E | Medium (10%) |
| `status` | 현재 진행 상태 | 필수 | B, E | Low (5%) |
| `project_link` | 원문/제안서 링크 | 필수 | A, C | High (30%) |
| `researcher_name` | 책임 연구원 정보 | 선택 | C | Medium (20%) |
| `budget_amount` | 연구비 규모 | 선택 | D | Low (10%) |
| *[추가 항목 1]* | [설명] | 선택 | ... | ... |
| *[추가 항목 2]* | [설명] | 선택 | ... | ... |
| *[... 총 13개 항목]* | ... | ... | ... | ... |

---

## ⚖️ ALTIT 매칭 점수 (AMS) 가중치 로직 초안

AMS는 수집된 데이터의 '수익화 연관성'을 평가합니다.

1.  **High Weight (30% 이상):** `project_name`, `project_link` (실질적인 연구 내용과 결과물 추적에 중요)
2.  **Medium Weight (15% ~ 30%):** `funding_source`, `submission_date` (자금 흐름 및 시의성 판단에 중요)
3.  **Low Weight (5% ~ 15%):** `keywords`, `budget_amount` (세부 분류 및 규모 파악에 중요)

**Developer 지시사항:** 데이터 수집 시, 위 가중치에 따라 각 필드에서 추출되는 정보의 정확도와 풍부함을 최우선으로 확보해야 합니다.

## 🚧 다음 단계 (Developer Action Items)
1.  위 Blueprint를 검토하고, **[기관명 A]** 에 대한 실제 API/크롤링 템플릿 설계(PoC)를 즉시 시작하십시오.
2.  PostgreSQL DB 스키마 설계(T1)를 이 Blueprint의 데이터 요구사항에 맞추어 확정하고, 분배 계획을 수립하십시오.