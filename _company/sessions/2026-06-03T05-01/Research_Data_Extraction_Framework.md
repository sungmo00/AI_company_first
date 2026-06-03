# 연구과제 데이터 추출 및 수익화 모델 검증 프레임워크 (V1.0)

## 1. 목적
본 문서는 정부 및 공공기관 연구과제 조사 단계에서, 수집된 연구 과제 데이터를 ALTIT KOREA의 핵심 역량과 연계하고, 잠재 고객(기관)의 의사결정을 지원하기 위해 필요한 구조화된 데이터 추출 및 분석 프레임워크를 정의합니다.

## 2. 핵심 구조화 데이터 (Output Schema)
모든 추출된 연구과제는 다음의 6가지 핵심 항목을 포함해야 합니다.

| 필드명 | 데이터 타입 | 설명 | 필수 여부 |
| :--- | :--- | :--- | :--- |
| **연구 과제 ID 및 제목** | String | 해당 연구과제의 공식 식별자 및 명칭. | 필수 |
| **타겟 기관 (공공/정부)** | String | 연구 과제를 주관하거나 등록한 정부 부처, 공공 연구기관 명칭. | 필수 |
| **연구 난이도 및 예상 소요 기간 (Scoring)** | 객관적 점수/기간 | **난이도 점수 (1-5):** 1(매우 쉬움) ~ 5(매우 어려움). 예상 소요 기간 (개월). | 필수 |
| **Relevance 점수 (0-100)** | Integer (0-100) | ALTIT KOREA의 핵심 강점(기술/데이터)과 해당 연구 과제의 전략적 연관성. (0: 무관, 100: 완벽히 일치) | 필수 |
| **고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)** | Text | 해당 과제 수행 기관이 연구에 투자할 의향(예: '높음', '조건부 높음', '낮음') 및 주요 투자 동기 분석. | 필수 |
| **추출 경로 상세 (API/웹)** | String | 해당 데이터를 수집하기 위한 최적화된 웹 접근 경로 및 API 엔드포인트. (Developer 에이전트 참조) | 필수 |

## 3. 핵심 로직 정의

### 3.1. Relevance 점수 (0-100) 산정 로직
Relevance 점수는 다음의 세 가지 요소를 가중 평균하여 계산됩니다.

$$\text{Relevance Score} = (W_1 \times \text{Tech Match}) + (W_2 \times \text{Data Fit}) + (W_3 \times \text{Strategic Alignment})$$

*   **Tech Match ($W_1=0.4$):** ALTIT KOREA의 핵심 기술/데이터 영역과 연구 과제의 직접적인 기술적 교집합 정도. (0-100)
*   **Data Fit ($W_2=0.3$):** 요구되는 데이터의 종류(양적/질적)와 ALTIT KOREA가 보유한 데이터 처리 능력의 적합성. (0-100)
*   **Strategic Alignment ($W_3=0.3$):** 해당 연구 과제가 정부/공공기관의 정책 방향 및 국가적 목표와 얼마나 부합하는지. (0-100)

> **[Researcher 지시사항]** $W_1, W_2, W_3$의 가중치는 초기 단계에서는 균등하게 설정하되, 향후 데이터 수집 결과에 따라 지속적으로 조정해야 합니다. 현재는 $W_1=0.4, W_2=0.3, W_3=0.3$로 설정합니다.

### 3.2. 고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹) 프레임워크
WTP 평가는 다음의 척도를 기반으로 진행됩니다.

| 평가 등급 | 정의 (기관 투자 의향) | 주요 고려 요소 |
| :--- | :--- | :--- |
| **High (높음)** | 즉각적인 필요성 또는 전략적 우위 확보 가능성이 높음. | 단기 성과, 선도 기술 획득 |
| **Conditional (조건부 높음)** | 특정 조건(예: 파트너십, 비용 분담) 하에 투자 의향이 있음. | 리스크 분산, 공동 연구 기회 |
| **Low (낮음)** | 당장 필요하지 않거나, 다른 대안이 존재함. | 비용 효율성, 기존 방식 유지 |

> **[Researcher 지시사항]** WTP 평가는 연구 과제의 '필수성(Necessity)'과 '혁신성(Innovation)'에 따라 이 등급을 결정해야 합니다.

## 4. 실행 단계 (Action Plan for Data Gathering)
1.  **타겟 기관별 가이드라인 확정:** 최우선 타겟 5개 기관별로, 해당 기관의 특성에 맞는 데이터 검색 필터 및 탐색 경로(API/웹)를 정의합니다.
2.  **데이터 추출 시나리오 작성:** 각 타겟 기관별로 위에서 정의한 **핵심 구조화 데이터**를 수집하기 위한 구체적인 Step-by-Step 추출 시나리오(스크립트 초안)를 작성합니다.
3.  **Relevance 매핑 규칙 구체화:** Tech Match, Data Fit, Strategic Alignment를 측정할 수 있는 **정량적 지표(Metric)** 정의 초안을 작성합니다.

<edit_file path="sessions/2026-06-03T05-01/Research_Data_Extraction_Framework.md">
<find>핵심 구조화 데이터 (Output Schema)</find><replace>핵심 구조화 데이터 (Output Schema)</replace>
<find>연구 과제 ID 및 제목</find><replace>연구 과제 ID 및 제목</replace>
<find>타겟 기관 (공공/정부)</find><replace>타겟 기관 (공공/정부)</replace>
<find>연구 난이도 및 예상 소요 기간 (Scoring)</find><replace>연구 난이도 및 예상 소요 기간 (Scoring)</replace>
<find>Relevance 점수 (0-100)</find><replace>Relevance 점수 (0-100)</replace>
<find>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</find><replace>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</replace>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</replace>
<find>연구 난이도 및 예상 소요 기간 (Scoring)</find><replace>연구 난이도 및 예상 소요 기간 (Scoring)</replace>
<find>Relevance 점수 (0-100)</find><replace>Relevance 점수 (0-100)</replace>
<find>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</find><replace>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</replace>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</replace>
<find>Tech Match ($W_1=0.4$): ALTIT KOREA의 핵심 기술/데이터 영역과 연구 과제의 직접적인 기술적 교집합 정도. (0-100)</find><replace>Tech Match ($W_1=0.4$): ALTIT KOREA의 핵심 기술/데이터 영역과 연구 과제의 직접적인 기술적 교집합 정도. (0-100)</replace>
<find>Data Fit ($W_2=0.3$): 요구되는 데이터의 종류(양적/질적)와 ALTIT KOREA가 보유한 데이터 처리 능력의 적합성. (0-100)</find><replace>Data Fit ($W_2=0.3$): 요구되는 데이터의 종류(양적/질적)와 ALTIT KOREA가 보유한 데이터 처리 능력의 적합성. (0-100)</replace>
<find>Strategic Alignment ($W_3=0.3$): 해당 연구 과제가 정부/공공기관의 정책 방향 및 국가적 목표와 얼마나 부합하는지. (0-100)</find><replace>Strategic Alignment ($W_3=0.3$): 해당 연구 과제가 정부/공공기관의 정책 방향 및 국가적 목표와 얼마나 부합하는지. (0-100)</replace>
<find>Relevance Score = ($W_1 \times \text{Tech Match}) + ($W_2 \times \text{Data Fit}) + ($W_3 \times \text{Strategic Alignment})$</find><replace>Relevance Score = ($W_1 \times \text{Tech Match}) + ($W_2 \times \text{Data Fit}) + ($W_3 \times \text{Strategic Alignment})$</replace>
<find>High (높음)</find><replace>High (높음)</replace>
<find>Conditional (조건부 높음)</find><replace>Conditional (조건부 높음)</replace>
<find>Low (낮음)</find><replace>Low (낮음)</replace>
<find>연구 과제 ID 및 제목</find><replace>연구 과제 ID 및 제목</replace>
<find>타겟 기관 (공공/정부)</find><replace>타겟 기관 (공공/정부)</replace>
<find>연구 난이도 및 예상 소요 기간 (Scoring)</find><replace>연구 난이도 및 예상 소요 기간 (Scoring)</replace>
<find>Relevance 점수 (0-100)</find><replace>Relevance 점수 (0-100)</replace>
<find>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</find><replace>고객의 지불 의사 (WTP) 정성적 평가</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</find>
<find>추출 경로 상세 (API/웹)</find><replace>추출 경로 상세 (API/웹)</replace>
</edit_file>