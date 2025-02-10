### **Spotify SQL Project**
This repository contains SQL queries and analysis based on Spotify listening data, focusing on user behavior and trends over the years.

![Spotify Logo](https://github.com/SumitraBishnoi/-Spotify-SQL-Project-/blob/main/spotify-logo.jpg)

---

## Project Overview

This project involves analyzing a **Spotify dataset** containing information about tracks, albums, and artists using advanced SQL techniques. The objective of the project is to practice advanced SQL skills, normalize a denormalized dataset, and optimize queries for performance. Throughout this project, we explore valuable insights from the dataset through exploratory data analysis (EDA), generate meaningful metrics, and perform advanced optimizations.

## Project Goals

- Normalize a denormalized Spotify dataset for better structure.
- Execute advanced SQL queries to extract insights and perform analysis.
- Optimize queries for faster execution and performance.
- Generate meaningful insights from music listening patterns and behaviors.
  
## Dataset

The dataset used in this project contains detailed information about Spotify streams, including attributes such as track name, artist, album, platform, and playtime. The data spans over several years and provides a comprehensive view of listening patterns.

## SQL Queries and Insights

### Data Preprocessing and Transformation

- **Data Cleaning & Transformation**: Removed rows with null values in `track_name`, added new columns like `minutes_played`, `play_date`, and `play_hour` for more granular analysis.
  
- **Track Duration Conversion**: Converted `ms_played` (milliseconds) to `minutes_played` for easier analysis.
  
- **Date and Hour Extraction**: Added columns to track the **date** and **hour** of play to analyze trends.

### Exploratory Data Analysis (EDA)
- **Total Listening Time**
- **Top 5 Most Played Songs**
- **Top 5 Most Played Artists**
- **Skipping Behavior**
- **Platform Distribution**
- **Streaming Trend by Hour**

#### These questions were answered
#### 1. **What Did You Listen To? 🎧**
- **Total Unique Tracks?**
- **Top Song?**
- **Most-Listened Artist?**
- **Favorite Album?**
- **Total Listening Hours?**
- **Monthly Breakdown?**
  
#### 2. **When Did You Listen? 🗓️**
- **Most Active Listening Month?**
- **Peak Listening Day?**
- **Hourly-Weekly Analysising Listening Behavior?**
- **Record-Breaking Day?**
  
#### 3. **How Did You Listen? 🔀**
- **Unfinished Play Rate?**
- **Shuffle Mode Usage?**
- **Most Skipped Time Interval?**
- **Start and End Reason Breakdown?**

#### 4. **Where Did You Listen? 📱**
- **Top Device for Streaming?**
- **Device Usage Trends?**

### Advanced SQL Queries

This project covers multiple **advanced SQL queries**, ranging from simple aggregations to complex analyses, such as:

- **Trend analysis by hour**: Identifying which hours of the day were most active for streaming.
- **Platform distribution**: Analyzing the total number of streams by platform (Android, WebPlayer, Windows, etc.).
- **Skip behavior analysis**: Analyzing the skip rate and identifying the time intervals where skips occurred the most.

### Query Optimization

Optimizing SQL queries is crucial when working with large datasets. In this project:

- **Optimized aggregate queries**: Ensured that **GROUP BY** clauses and **JOINs** were efficiently handled to reduce query time.
- **Used efficient filtering techniques**: Optimized queries by leveraging proper indexing and avoiding unnecessary computations.
 
## Insights & Storytelling

This section highlights key insights and visualizations derived from the data, offering a deeper understanding of music listening patterns.

### **1. What Did You Listen To? 🎧**
- **Unique Tracks**: 13,665 tracks played over 12 years.
- **Top Song**: "Ode to the Mets", with 207 plays.
- **Most-Listened Artist**: "The Beatles", with 336+ hours of listening.
- **Favorite Album**: "The New Abnormal".
- **Total Listening Hours**: 222 days, 13 hours, 32 minutes of music played.
- **Month-wise Breakdown**: Observed fluctuations in music taste, with a noticeable peak in new discoveries during certain months.

### **2. When Did You Listen? 🗓️**
- **Most Active Listening Month**: October, with 23+ days of listening time.
- **Peak Listening Day**: Friday, recording 883 hours of listening.
- **Hourly-Weekly Heatmap**: Peak listening occurred between 5 PM to 1 AM, reflecting a preference for late-night listening.
- **Record-Breaking Day**: **Saturday, 15 August 2020**, with **13 hours, 29 minutes, and 27 seconds** of streaming, marking a significant event.

### **3. How Did You Listen? 🔀**
- **Unfinished Play Rate**: 48.5% – showing a selective listening behavior.
- **Shuffle Mode Usage**: 74%, indicating a preference for random tracks.
- **Most Skipped Interval**: The first 5 seconds of a song, highlighting the need for engaging intros.
- **Reason Breakdown for Start and End of Tracks**: Most tracks were ended due to the user selecting "trackdone" or skipping using the forward button.

### **4. Where Did You Listen? 📱**
- **Top Device**: Android, accounting for 91% of total playtime.
- **Device Usage**: Android consistently grew in popularity after 2014, replacing Windows and WebPlayer.

## Setup and Installation

To run this project locally, you will need to set up the following:

1. **Clone the repository:**

```bash
git clone https://github.com/SumitraBishnoi/Spotify-SQL-Project.git
cd Spotify-SQL-Project
