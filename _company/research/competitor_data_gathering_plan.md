# 경쟁사 가격 정책 및 시장 침투율 데이터 수집 계획 (ROI 근거 자료 준비)

## 1. 목표
수익화 모델 1안의 최종 가격 구조 확정을 위해, 핵심 경쟁사 2곳의 **가격 정책(Pricing)** 및 **시장 침투율 추정치(Market Penetration Rate Estimate)** 데이터를 확보하고, 이를 기반으로 ROI 검증 근거 자료를 마련한다.

## 2. 분석 대상 선정 (가정)
본 연구는 ALTIT KOREA의 **'정부/공공기관 대상 연구 과제 제안 및 수주 지원 서비스'**라는 핵심 가치에 초점을 맞춘다.

*   **경쟁사 1 (Target A):** 정부/공공기관 대상 전문 컨설팅 및 제안서 작성 대행 분야의 선두 기업 (예: 정부 R&D 지원 전문 컨설팅사)
*   **경쟁사 2 (Target B):** 유사한 형태의 공공 부문 대상 기술/정책 제안 서비스 제공 기업 (예: 공공기관 특화된 정책 연구 및 입찰 지원 플랫폼)

## 3. 데이터 요구사항 (Schema Definition)
각 경쟁사별로 다음 항목을 수집해야 한다.

| Category | Data Field | Description | Source Type | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **Pricing** | Base Price Range (KRW/USD) | 핵심 서비스 패키지별 기본 가격대 | Web Scraping / Press Release | High |
| **Pricing** | Tiered Options | Basic, Premium, Enterprise 등 단계별 가격 구조 | Web Scraping | High |
| **Service** | Core Offering Details | 제공하는 핵심 서비스 항목 (제안서 작성, 행정 지원 등) | Website Review | Medium |
| **Market** | Estimated Market Share (%) | 해당 시장 내 추정 점유율 (공개 보고서 기반) | Industry Report Search | High |
| **Market** | Penetration Velocity | 최근 1년간의 시장 성장률 또는 침투 속도 추정치 | News/Analyst Reports | Medium |

## 4. 데이터 수집 시나리오 (Step-by-Step)
1.  **Phase 1: Target Identification:** 선정된 경쟁사 1과 2의 공식 웹사이트, 보도자료 아카이브를 식별한다.
2.  **Phase 2: Pricing Extraction:** 각 사이트에서 가격 정보(Pricing, Packages)를 추출하는 크롤링 시나리오를 작성한다. (Target A & B 별로 분리)
3.  **Phase 3: Market Data Sourcing:** Industry Report 데이터베이스 및 전문 분석 리포트(유료/무료)를 검색하여 시장 점유율 데이터를 확보한다.
4.  **Phase 4: Data Synthesis:** 수집된 정성/정량 데이터를 통합하여, '경쟁사 1 vs. 경쟁사 2' 비교 매트릭스를 생성한다.

## 5. 다음 액션 (Researcher의 역할)
*   Phase 1 실행: Target A와 B에 대한 구체적인 웹 접근 경로(URL, API 엔드포인트 초안)를 조사하여 제공한다.
*   Phase 2/3 준비: 각 단계별로 필요한 크롤링 대상 URL 리스트와 검색 키워드 목록을 작성한다.
*   **결과물:** 최종적으로 현빈 에이전트가 ROI 계산에 바로 사용할 수 있는 **'경쟁사 비교 데이터 테이블(Draft)'**을 준비한다.