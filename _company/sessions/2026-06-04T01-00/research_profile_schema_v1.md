# 연구과제별 요구사항 프로파일링 및 매핑 데이터셋 스키마 정의서 (V1.0)

## 1. 목적
본 문서의 목적은 정부 및 공공기관에 등록된 연구과제 정보를 기반으로, **ALTIT KOREA의 핵심 역량(Capability)과 각 연구과제가 요구하는 구체적인 기술/정책적 요구사항(Requirement Profile) 간의 정량적 매핑 데이터셋**을 구축하기 위한 최종 스키마를 정의하는 것입니다. 이 데이터셋은 Business 에이전트가 연구과제 매칭의 성공률을 극대화하는 프레임워크를 설계하는 데 필요한 원천 데이터로 사용됩니다.

## 2. 핵심 엔티티 (Entities)
1. **연구과제 정보 (Research Project)**: 기관에서 등록된 실제 연구 과제의 메타데이터.
2. **요구사항 프로파일 (Requirement Profile)**: 해당 연구과제가 요구하는 기술적, 정책적 세부 사항.
3. **ALTIT 역량 (ALTIT Capability)**: ALTIT KOREA가 보유한 기술적/정책적 역량 수준.

## 3. 데이터셋 스키마 정의 (Data Schema Definition)

### A. 연구과제 정보 (Research Project)
| 필드명 | 데이터 타입 | 필수 여부 | 설명 | 비고 (Source/Notes) |
| :--- | :--- | :--- | :--- | :--- |
| `project_id` | String | 필수 | 연구과제의 고유 식별자 | 기관 제공 ID |
| `target_agency` | String | 필수 | 연구과제를 제출/수행하고자 하는 기관 (예: 과기정통부, KIST) | 필터링 기준 |
| `field_domain` | String | 필수 | 연구 분야의 최상위 분류 (예: AI, 양자컴퓨팅, 바이오) | Taxonomy Mapping 필요 |
| `project_title` | String | 필수 | 연구과제 제목 | 원문 |
| `submission_date` | Date | 선택 | 과제 제출 또는 등록일 | 시간 기반 분석 |
| `funding_source` | String | 선택 | 자금 지원 주체 (정부, 민간 등) | |
| `project_scope` | String | 필수 | 연구과제의 핵심 목표 및 범위 요약 | NLP 추출 필요 |
| `keywords` | List[String] | 선택 | 과제 관련 핵심 키워드 | NLP 추출 필요 |

### B. 요구사항 프로파일 (Requirement Profile)
| 필드명 | 데이터 타입 | 필수 여부 | 설명 | 비고 (Source/Notes) |
| :--- | :--- | :--- | :--- | :--- |
| `requirement_id` | String | 필수 | 프로파일 고유 식별자 | 생성 시 부여 |
| `domain_match` | String | 필수 | 연구과제와 ALTIT 역량 간의 도메인 매칭 점수 (0.0 ~ 1.0) | **핵심 매핑 지표** |
| `technical_spec_req` | List[String] | 필수 | 요구되는 구체적인 기술 스펙 (예: Latency < 10ms, Specific Algorithm X) | 상세 분석 필요 |
| `policy_compliance` | List[String] | 필수 | 준수해야 할 정책/규제 사항 (예: GDPR, 특정 보안 표준) | 규제 데이터베이스 연동 필요 |
| `resource_demand` | Dict | 필수 | 요구되는 인력 규모 및 기간 (Man-Month, Required Expertise Level) | 코다리 검토 필요 |
| `risk_factor` | Float | 선택 | 해당 과제의 잠재적 기술적 위험도 (1.0 = High Risk) | 자체 평가 또는 외부 데이터 연동 |

### C. ALTIT 역량 (ALTIT Capability)
| 필드명 | 데이터 타입 | 필수 여부 | 설명 | 비고 (Source/Notes) |
| :--- | :--- | :--- | :--- | :--- |
| `capability_id` | String | 필수 | ALTIT KOREA의 역량 고유 식별자 | 내부 정의 |
| `core_technology` | List[String] | 필수 | 보유한 핵심 기술 스택 (예: ML Model A, Quantum Simulation B) | 개발팀 연계 |
| `expertise_level` | Float | 필수 | 해당 기술에 대한 보유 숙련도 (1.0 ~ 5.0) | 내부 평가 기반 |
| `compliance_score` | Float | 필수 | 보유하고 있는 인증/규제 준수 수준 | 규제 데이터 연동 필요 |
| `competitive_edge` | String | 선택 | 경쟁사 대비 차별화 포인트 (Unique Selling Point) | Business 연계 |

## 4. 매핑 로직 정의 (Mapping Logic - AMS Framework)
**목표:** $\text{ALTIT Capability} \times \text{Requirement Profile} \rightarrow \text{ALTIT Matching Score (AMS)}$

$$
\text{AMS} = W_1 \cdot (\text{Domain Match Score}) + W_2 \cdot (\text{Technical Fit}) + W_3 \cdot (\text{Compliance Match})
$$

*   $W_1, W_2, W_3$: 전략적 중요도에 따른 가중치 ($W_1 + W_2 + W_3 = 1.0$).
*   **$W_1$ (Domain Match Score):** `domain_match` 필드에 기반하여 산출. (가중치 $W_1=0.5$로 초기 설정)
*   **$W_2$ (Technical Fit):** `technical_spec_req`와 `core_technology` 간의 교차 검증을 통해 산출.
*   **$W_3$ (Compliance Match):** `policy_compliance`와 `compliance_score` 간의 일치도를 기반으로 산출.

---

## 5. 다음 단계 (Next Steps for Data Acquisition)
1.  **데이터 수집 우선순위:** 최우선 타겟 5개 기관별로, 위 스키마의 **'연구과제 정보'** 항목을 수집하는 데 필요한 구체적인 검색 쿼리 및 API 엔드포인트 목록을 작성합니다.
2.  **코다리 검토 요청:** 위 스키마의 **'요구사항 프로파일'** 및 **'매핑 로직 정의(AMS)'** 부분에 대해 기술적 구현 가능성 및 데이터 추출 난이도 분석 피드백을 요청합니다. (Phase 1 Task Breakdown 검토 시 활용)