SELECT
   DISTINCT
   SUBSTR(b.campaign, 6, 3),
   event.activity_id,
   AVG(
     TIMESTAMP_DIFF(
       TIMESTAMP_MICROS(CAST(event.event_time AS INT64)), 
       TIMESTAMP_MICROS(CAST(event.interaction_time_utc_seconds AS INT64)), 
       MINUTE)
     ) AS avg_ttc,
   COUNT(*) AS volume
FROM adh.cm_dt_activities a
LEFT JOIN adh.cm_dt_campaign b
ON a.event.campaign_id = b.campaign_id
WHERE event.campaign_id IN
   (SELECT
      DISTINCT campaign_id
    FROM adh.cm_dt_campaign
    WHERE SUBSTR(campaign, 6, 3) IN (@marketing_initative)
    )
GROUP BY 1,2
ORDER BY 4 DESC
