-- PostgreSQL DB Schema Final Version V2 (Based on Researcher's Path Guide)

-- Table: target_institutions
CREATE TABLE IF NOT EXISTS target_institutions (
    institution_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    target_type VARCHAR(100) NOT NULL, -- 예: 'Government', 'Research Institute'
    priority_score INT NOT NULL,        -- Researcher가 정의한 중요도 점수 (1-10)
    access_type VARCHAR(50),             -- API, Web Scraping, Manual
    initial_url TEXT,                    -- 초기 접근 URL 또는 Endpoint
    status VARCHAR(50) DEFAULT 'Pending' -- Pending, Acquired, Failed
);

-- Table: collected_data_metadata
CREATE TABLE IF NOT EXISTS collected_data_metadata (
    record_id BIGSERIAL PRIMARY KEY,
    institution_id INT REFERENCES target_institutions(institution_id),
    extraction_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    data_source VARCHAR(100) NOT NULL, -- API/Scraped URL
    raw_data_location TEXT,             -- 실제 데이터 저장 위치 (S3/Local Path)
    ingestion_status VARCHAR(50) DEFAULT 'Raw', -- Raw, Validated, Transformed, Loaded
    processing_error TEXT,              -- 에러 발생 시 기록
    validation_score DECIMAL(5, 2),     -- 데이터 유효성 검증 점수 (0.00 - 1.00)
    processed_record_count INT,         -- 이 레코드에서 추출된 최종 항목 수
    CONSTRAINT fk_institution FOREIGN KEY (institution_id) REFERENCES target_institutions(institution_id)
);

-- Table: research_records (Core Data Structure based on Researcher's 13 Columns)
CREATE TABLE IF NOT EXISTS research_records (
    record_id BIGSERIAL PRIMARY KEY,
    collected_data_id BIGINT REFERENCES collected_data_metadata(record_id),
    title VARCHAR(512) NOT NULL,
    abstract TEXT,
    keywords TEXT[], -- 배열 타입으로 다중 키워드 저장
    funding_opportunity_id VARCHAR(100), -- 연관된 과제 ID (선택적)
    research_focus TEXT,
    data_integrity_check BOOLEAN DEFAULT FALSE, -- 데이터 무결성 검사 여부
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_collected_data FOREIGN KEY (collected_data_id) REFERENCES collected_data_metadata(record_id)
);

-- Indexing for performance
CREATE INDEX IF NOT EXISTS idx_metadata_institution_id ON collected_data_metadata(institution_id);
CREATE INDEX IF NOT EXISTS idx_records_focus ON research_records(research_focus);

-- Initial Data Seeding (Example structure based on the 13 required columns)
INSERT INTO target_institutions (name, target_type, priority_score, access_type, initial_url) VALUES
('기관 A', 'Government', 9, 'API', 'https://api.gov/a'),
('기관 B', 'Research Institute', 8, 'Web Scraping', 'http://www.researchb.com');