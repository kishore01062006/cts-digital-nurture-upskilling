SELECT 'Initializing database schema...' AS info;
SOURCE schema.sql;

SELECT 'Seeding sample data...' AS info;
SOURCE data.sql;

SELECT 'Running all 25 queries...' AS info;
SOURCE queries.sql;

SELECT 'All scripts executed successfully!' AS info;
