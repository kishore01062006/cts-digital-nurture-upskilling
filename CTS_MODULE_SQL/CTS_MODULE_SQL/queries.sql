USE events_db;

SELECT 
    u.user_id,
    u.full_name AS user_name,
    u.city AS user_city,
    e.event_id,
    e.title AS event_title,
    e.start_date AS event_start_date
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
JOIN Events e ON r.event_id = e.event_id
WHERE e.status = 'upcoming' 
  AND e.city = u.city
ORDER BY e.start_date ASC;

SELECT 
    e.event_id,
    e.title AS event_title,
    AVG(f.rating) AS avg_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;

SELECT 
    u.user_id,
    u.full_name,
    u.email,
    u.registration_date
FROM Users u
WHERE u.user_id NOT IN (
    SELECT DISTINCT r.user_id
    FROM Registrations r
    WHERE r.registration_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
);

SELECT 
    e.event_id,
    e.title AS event_title,
    COUNT(s.session_id) AS sessions_10am_to_12pm
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id 
    AND TIME(s.start_time) >= '10:00:00' 
    AND TIME(s.end_time) <= '12:00:00'
GROUP BY e.event_id, e.title;

SELECT 
    e.city AS event_city,
    COUNT(DISTINCT r.user_id) AS distinct_user_registrations
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.city
ORDER BY distinct_user_registrations DESC
LIMIT 5;

SELECT 
    e.event_id,
    e.title AS event_title,
    SUM(CASE WHEN r.resource_type = 'pdf' THEN 1 ELSE 0 END) AS pdf_count,
    SUM(CASE WHEN r.resource_type = 'image' THEN 1 ELSE 0 END) AS image_count,
    SUM(CASE WHEN r.resource_type = 'link' THEN 1 ELSE 0 END) AS link_count,
    COUNT(r.resource_id) AS total_resources
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title;

SELECT 
    u.user_id,
    u.full_name AS user_name,
    e.title AS event_name,
    f.rating,
    f.comments,
    f.feedback_date
FROM Feedback f
JOIN Users u ON f.user_id = u.user_id
JOIN Events e ON f.event_id = e.event_id
WHERE f.rating < 3;

SELECT 
    e.event_id,
    e.title AS event_title,
    COUNT(s.session_id) AS session_count
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id, e.title;

SELECT 
    u.user_id AS organizer_id,
    u.full_name AS organizer_name,
    SUM(CASE WHEN e.status = 'upcoming' THEN 1 ELSE 0 END) AS upcoming_events,
    SUM(CASE WHEN e.status = 'completed' THEN 1 ELSE 0 END) AS completed_events,
    SUM(CASE WHEN e.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_events,
    COUNT(e.event_id) AS total_events
FROM Users u
JOIN Events e ON u.user_id = e.organizer_id
GROUP BY u.user_id, u.full_name;

SELECT DISTINCT 
    e.event_id,
    e.title AS event_title
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM Feedback f 
    WHERE f.event_id = e.event_id
);

SELECT 
    registration_date,
    COUNT(user_id) AS new_users_registered
FROM Users
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
GROUP BY registration_date
ORDER BY registration_date DESC;

WITH EventSessionCounts AS (
    SELECT 
        event_id,
        COUNT(session_id) AS session_count
    FROM Sessions
    GROUP BY event_id
)
SELECT 
    e.event_id,
    e.title AS event_title,
    esc.session_count
FROM Events e
JOIN EventSessionCounts esc ON e.event_id = esc.event_id
WHERE esc.session_count = (SELECT MAX(session_count) FROM EventSessionCounts);

SELECT 
    e.city AS event_city,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS total_feedbacks
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.city
ORDER BY average_rating DESC;

SELECT 
    e.event_id,
    e.title AS event_title,
    COUNT(r.registration_id) AS registration_count
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title
ORDER BY registration_count DESC
LIMIT 3;

SELECT 
    s1.event_id,
    e.title AS event_title,
    s1.session_id AS session1_id,
    s1.title AS session1_title,
    s1.start_time AS session1_start,
    s1.end_time AS session1_end,
    s2.session_id AS session2_id,
    s2.title AS session2_title,
    s2.start_time AS session2_start,
    s2.end_time AS session2_end
FROM Sessions s1
JOIN Sessions s2 ON s1.event_id = s2.event_id AND s1.session_id < s2.session_id
JOIN Events e ON s1.event_id = e.event_id
WHERE s1.start_time < s2.end_time 
  AND s1.end_time > s2.start_time;

SELECT 
    u.user_id,
    u.full_name,
    u.email,
    u.registration_date
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id
WHERE u.registration_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  AND r.registration_id IS NULL;

SELECT 
    speaker_name,
    COUNT(session_id) AS session_count
FROM Sessions
GROUP BY speaker_name
HAVING COUNT(session_id) > 1;

SELECT 
    e.event_id,
    e.title AS event_title
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;

SELECT 
    e.event_id,
    e.title AS event_title,
    (SELECT COUNT(*) FROM Registrations r WHERE r.event_id = e.event_id) AS total_registrations,
    (SELECT AVG(f.rating) FROM Feedback f WHERE f.event_id = e.event_id) AS avg_feedback_rating
FROM Events e
WHERE e.status = 'completed';

SELECT 
    u.user_id,
    u.full_name,
    (SELECT COUNT(*) FROM Registrations r WHERE r.user_id = u.user_id) AS events_attended,
    (SELECT COUNT(*) FROM Feedback f WHERE f.user_id = u.user_id) AS feedbacks_submitted
FROM Users u;

SELECT 
    u.user_id,
    u.full_name,
    COUNT(f.feedback_id) AS feedback_count
FROM Users u
JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name
ORDER BY feedback_count DESC
LIMIT 5;

SELECT 
    user_id,
    event_id,
    COUNT(registration_id) AS registration_count
FROM Registrations
GROUP BY user_id, event_id
HAVING COUNT(registration_id) > 1;

SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') AS registration_month,
    COUNT(registration_id) AS registration_count
FROM Registrations
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY registration_month ASC;

SELECT 
    e.event_id,
    e.title AS event_title,
    AVG(TIMESTAMPDIFF(MINUTE, s.start_time, s.end_time)) AS avg_session_duration_minutes
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title;

SELECT 
    e.event_id,
    e.title AS event_title
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE s.session_id IS NULL;
