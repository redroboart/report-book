-- ==============================================================================
-- Supabase Schema & Seed: Roopnagar Popularity Check Report
-- ==============================================================================

-- 1. Create Reports Table (if not exists)
CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL DEFAULT 'roopnagar',
    title TEXT NOT NULL,
    data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Trigger for updating updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS 25632
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
25632 language 'plpgsql';

DROP TRIGGER IF EXISTS set_reports_updated_at ON public.reports;
CREATE TRIGGER set_reports_updated_at
BEFORE UPDATE ON public.reports
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- 2. Row Level Security (RLS)
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access" ON public.reports;
CREATE POLICY "Allow public read access"
ON public.reports
FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to modify reports" ON public.reports;
CREATE POLICY "Allow authenticated users to modify reports"
ON public.reports
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- 3. Upsert Roopnagar Report Data
INSERT INTO public.reports (slug, title, data)
VALUES (
    'roopnagar',
    'Roopnagar Popularity Check: Seven Aspirants',
    '{
  "meta": {
    "placeholder": false,
    "sameContest": true,
    "title": "Roopnagar Popularity Check: Seven Aspirants",
    "subtitle": "Monte Carlo simulated field report on candidate recall, popularity, and voter favorability in Roopnagar (Ropar), prepared for Waris Punjab De.",
    "client": "Waris Punjab De",
    "constituency": "Roopnagar (Ropar)",
    "fieldDates": "October 2026",
    "sampleSize": 1797,
    "marginOfError": 2.3,
    "simulationIterations": 10000,
    "pulseLabels": [
      "P1",
      "P2",
      "P3",
      "P4",
      "P5",
      "P6"
    ],
    "preparedBy": "CCPA Research Desk"
  },
  "candidates": [
    {
      "id": "SB",
      "name": "Sukhwinder Singh Barwa",
      "party": "Waris Punjab De / Akali",
      "isClient": true,
      "firstTime": true,
      "tagline": "Nurpur Bedi rural entrepreneur & Panthak activist (Barwa Dairy & Agri Solutions); decisive leader in Akali voter favorability (65%) with deep philanthropic roots.",
      "age": "30s (Married Dec 2024)",
      "gender": "Male",
      "education": "Graduate",
      "profession": "Rural Entrepreneur & Agrarian Organiser",
      "hometown": "Barwa, Nurpur Bedi",
      "publicRole": "Grassroots philanthropist & Panthak organiser",
      "languages": "Punjabi, Hindi",
      "socialReach": "Active since 2020 Kisan Morcha (38K followers)",
      "recall": 53,
      "recallRange": [
        50.6,
        55.2
      ],
      "favourable": 65,
      "favourableRange": [
        61.0,
        68.7
      ],
      "unfavourable": 15,
      "unfavourableRange": [
        13.2,
        17.1
      ],
      "intent": 22,
      "intentRange": [
        20.3,
        24.2
      ],
      "trend": [
        16,
        17,
        19,
        20,
        21,
        22
      ],
      "enterprises": "Barwa Dairy & Agri Solutions, Barwa Agriculture Farm, Seed Store",
      "areaOfOperations": "Nurpur Bedi area & rural agrarian belt",
      "community": "Sikh",
      "bio": "Based in Nurpur Bedi, Sukhwinder Singh Barwa is a prominent rural entrepreneur and community organizer. His public engagement surged immediately following the 2020 Delhi Kisan Morcha, where he was actively involved through ''Sanjhi Sath'' and subsequently organized extensive flood relief campaigns across Roopnagar. He operates Barwa Dairy & Agri Solutions and Barwa Agriculture Farm, dealing in seeds and dairy equipment and maintaining close ties with local dairy farmers. Over the past three years, he has worked closely with Manpreet Singh Ayali across key Panthak and democratic causes.",
      "panthakRecord": "Active across major Panthak & civil rights issues: Beadbi, Bandi Singhs, Satluj film screening, Fake Encounters, Release of Bhai Amritpal Singh, opposing Ram Rahim & Bikram Majithia release/parole, Panjab University autonomy, and BBMB rights. Consistently vocal against RSS influence and attacks on democratic rights.",
      "pros": "Young, activist, rural entrepreneur, and philanthropic outlook gives him the highest penetrating power across varied demographics in Roopnagar. Minimal voter resistance (only 15% unfavourable, +50 net score).",
      "cons": "Faces the threat of traditional party money power, liquor distribution, and patronage machinery intensifying in late-stage campaign phases."
    },
    {
      "id": "GG",
      "name": "Gurinder Singh Gogi",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Veteran political survivor (25.3% Akali favorability); extensive municipal experience but burdened by frequent party switching.",
      "age": "50s",
      "gender": "Male",
      "education": "Graduate",
      "profession": "Trader and political representative",
      "hometown": "Roopnagar Town",
      "publicRole": "Former municipal councillor & political organiser",
      "languages": "Punjabi, Hindi",
      "socialReach": "Muted online presence (18K followers)",
      "recall": 37,
      "recallRange": [
        35.0,
        39.5
      ],
      "favourable": 38,
      "favourableRange": [
        35.2,
        40.8
      ],
      "unfavourable": 18,
      "unfavourableRange": [
        16.0,
        20.1
      ],
      "intent": 9,
      "intentRange": [
        7.4,
        10.0
      ],
      "trend": [
        7,
        8,
        8,
        8,
        9,
        9
      ],
      "areaOfOperations": "Roopnagar municipal wards & urban commercial pockets",
      "community": "Sikh",
      "bio": "A seasoned municipal representative from Roopnagar Town, Gurinder Singh Gogi has remained a familiar figure in local urban politics for decades. While adept at maintaining political relevance across changing administrations, his digital and social media footprint remains muted.",
      "pros": "Resilient political survivor who has consistently found mechanisms to retain local visibility and cadre connections across multiple election cycles.",
      "cons": "Chronic party hopper\u2014has switched between Akali Dal, Congress, AAP, and back to Akali Dal multiple times. In a cycle where the WPD wave is seen as a youth-led call for principled change, his transactional history fails to resonate with younger voters."
    },
    {
      "id": "DJ",
      "name": "Dalvir Jatana",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Cousin of Shaheed Bhai Balwinder Singh Jatana (17.6% favorability); strong symbolic heritage tempered by public family infighting.",
      "age": "55",
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Agriculturist",
      "hometown": "Jatana, Roopnagar",
      "publicRole": "WPD aspirant & agrarian activist",
      "languages": "Punjabi, Hindi",
      "socialReach": "Recently activated (12K followers)",
      "recall": 23,
      "recallRange": [
        21.3,
        25.2
      ],
      "favourable": 26,
      "favourableRange": [
        23.6,
        28.5
      ],
      "unfavourable": 16,
      "unfavourableRange": [
        14.1,
        18.0
      ],
      "intent": 6,
      "intentRange": [
        5.0,
        7.2
      ],
      "trend": [
        4,
        5,
        5,
        5,
        6,
        6
      ],
      "areaOfOperations": "Jatana rural pocket & agrarian panchayats",
      "community": "Sikh",
      "bio": "Dalvir Singh Jatana is the cousin of revered martyr Shaheed Bhai Balwinder Singh Jatana. Newly activated in formal electoral politics, his public and social media presence has emerged only recently as an aspirant for the Waris Punjab De banner.",
      "panthakRecord": "Draws direct moral authority from the legacy of Bhai Balwinder Singh Jatana, carrying high symbolic reverence among orthodox Panthak households.",
      "pros": "Immediate emotional resonance among orthodox Panthak families and SYL canal resistance history.",
      "cons": "Internal family disputes and infighting have spilled into the public domain, creating confusion and limiting his ability to build a unified campaign apparatus."
    },
    {
      "id": "JA",
      "name": "Jarnail Singh Aulakh",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Durable elder recall (56% in 51+), but lowest voter favorability conversion (12.2%) with declining tracking momentum.",
      "age": "52",
      "gender": "Male",
      "education": "Graduate",
      "profession": "Senior community worker",
      "hometown": "Aulakh, Roopnagar",
      "publicRole": "Panthic circle veteran",
      "languages": "Punjabi, Hindi",
      "socialReach": "15K followers",
      "recall": 41,
      "recallRange": [
        38.5,
        43.0
      ],
      "favourable": 28,
      "favourableRange": [
        25.5,
        30.6
      ],
      "unfavourable": 22,
      "unfavourableRange": [
        19.8,
        24.3
      ],
      "intent": 4,
      "intentRange": [
        3.3,
        5.1
      ],
      "trend": [
        5,
        5,
        4,
        4,
        4,
        4
      ],
      "areaOfOperations": "Aulakh & traditional Panthak circles",
      "community": "Sikh",
      "bio": "A veteran of regional Akali and Panthak agitations, Jarnail Singh Aulakh has decades of organizational history in rural Roopnagar. While respected among senior citizens, he lacks contemporary digital infrastructure.",
      "pros": "Strong, trusted name recognition among senior voters (56% recall in ages 51+) and traditional Akali elders.",
      "cons": "Low conversion from familiarity into voting intent (only 4% intent), showing signs of voter fatigue and gradual attrition across tracking waves."
    },
    {
      "id": "AL",
      "name": "Ajaiveer Lalpura",
      "party": "BJP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Highest overall name recall (73.3%) driven by prominent family background; strong in Hindu (83%) and BC (81%) belts but capped by 32% unfavorability.",
      "age": "35",
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Youth leader & entrepreneur",
      "hometown": "Anandpur Sahib / Roopnagar",
      "publicRole": "BJP youth face (Son of NCM Chairman Iqbal Singh Lalpura)",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "85K followers (high digital ad spend)",
      "recall": 73,
      "recallRange": [
        71.2,
        75.3
      ],
      "favourable": 42,
      "favourableRange": [
        39.8,
        44.4
      ],
      "unfavourable": 32,
      "unfavourableRange": [
        29.8,
        34.3
      ],
      "intent": 18,
      "intentRange": [
        16.2,
        19.8
      ],
      "trend": [
        15,
        16,
        17,
        17,
        18,
        18
      ],
      "areaOfOperations": "Roopnagar city, Anandpur corridor, Hindu & BC belts",
      "community": "Sikh (BJP platform)",
      "bio": "Ajaiveer Lalpura is the prominent youth face of the BJP in the region, benefiting from the political stature and resources of his father, Iqbal Singh Lalpura (Chairman, National Commission for Minorities). He has deployed an expansive digital presence and active youth club sponsorships.",
      "pros": "Commands dominant recall in Hindu (83%) and Backward Class (81%) urban/semi-urban segments, backed by formidable financial and media resources.",
      "cons": "High voter hostility ceiling (32% unfavourable), facing deep ideological and agrarian resistance across rural Sikh panchayats that caps his growth at 18%."
    },
    {
      "id": "AS",
      "name": "Ashwani Sharma",
      "party": "Congress",
      "isClient": false,
      "firstTime": true,
      "tagline": "Long-standing Congress party loyalist (14% intent); dependable support in urban Hindu pockets but hindered by low youth engagement.",
      "age": "50s",
      "gender": "Male",
      "education": "Professional Degree",
      "profession": "Advocate",
      "hometown": "Roopnagar City",
      "publicRole": "Congress veteran & legal cell representative",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "Minimal social media presence (24K followers)",
      "recall": 45,
      "recallRange": [
        43.0,
        47.6
      ],
      "favourable": 36,
      "favourableRange": [
        33.7,
        38.3
      ],
      "unfavourable": 24,
      "unfavourableRange": [
        21.8,
        26.2
      ],
      "intent": 14,
      "intentRange": [
        12.4,
        15.6
      ],
      "trend": [
        12,
        13,
        13,
        14,
        14,
        14
      ],
      "areaOfOperations": "Roopnagar town, legal fraternity & urban wards",
      "community": "Sharma (Hindu / Brahmin)",
      "bio": "An advocate by profession and a senior Congress loyalist, Ashwani Sharma has served the party machinery for decades. He is active in municipal legal circles and traditional Congress ward committees.",
      "pros": "Deep-rooted organizational standing within Congress cadre; reliable baseline in urban merchant and Hindu pockets.",
      "cons": "Virtually absent from social media; unable to connect with voters under 35 or make inroads into the rural agrarian constituency."
    },
    {
      "id": "RM",
      "name": "Ramkumar Mukari",
      "party": "AAP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Young and enthusiastic Saini community face for AAP (11% intent); constrained by CM decoupling and thin local ground presence.",
      "age": "30s",
      "gender": "Male",
      "education": "Graduate",
      "profession": "Social organiser & party coordinator",
      "hometown": "Mukari, Roopnagar",
      "publicRole": "AAP constituency coordinator",
      "languages": "Punjabi, Hindi",
      "socialReach": "19K followers",
      "recall": 30,
      "recallRange": [
        27.5,
        31.8
      ],
      "favourable": 29,
      "favourableRange": [
        26.8,
        31.2
      ],
      "unfavourable": 20,
      "unfavourableRange": [
        18.0,
        22.1
      ],
      "intent": 11,
      "intentRange": [
        9.5,
        12.5
      ],
      "trend": [
        9,
        10,
        10,
        10,
        11,
        11
      ],
      "areaOfOperations": "Mukari village, Saini community belt & rural blocks",
      "community": "Saini",
      "bio": "A young and enthusiastic local organizer from Mukari village, Ramkumar Mukari represents the AAP party machinery and belongs to the influential local Saini community.",
      "pros": "Solid representation within the Saini voter base and institutional backing from the governing AAP apparatus.",
      "cons": "Weak personal brand awareness (only 32% recall even among Bhagwant Mann backers); heavily vulnerable to local anti-incumbency and CM decoupling."
    }
  ],
  "segments": [
    {
      "group": "Age",
      "label": "18\u201325",
      "n": 282,
      "values": {
        "SB": 50,
        "GG": 23,
        "DJ": 18,
        "JA": 16,
        "AL": 67,
        "AS": 29,
        "RM": 17
      },
      "ranges": {
        "SB": [
          44.0,
          55.7
        ],
        "GG": [
          18.4,
          28.4
        ],
        "DJ": [
          13.8,
          22.7
        ],
        "JA": [
          11.7,
          20.2
        ],
        "AL": [
          61.7,
          72.3
        ],
        "AS": [
          23.4,
          34.0
        ],
        "RM": [
          12.8,
          21.3
        ]
      }
    },
    {
      "group": "Age",
      "label": "26\u201335",
      "n": 438,
      "values": {
        "SB": 53,
        "GG": 31,
        "DJ": 20,
        "JA": 30,
        "AL": 75,
        "AS": 41,
        "RM": 23
      },
      "ranges": {
        "SB": [
          48.6,
          58.2
        ],
        "GG": [
          26.5,
          35.2
        ],
        "DJ": [
          16.2,
          23.7
        ],
        "JA": [
          26.0,
          34.5
        ],
        "AL": [
          71.2,
          79.2
        ],
        "AS": [
          36.5,
          45.9
        ],
        "RM": [
          19.4,
          27.4
        ]
      }
    },
    {
      "group": "Age",
      "label": "36\u201350",
      "n": 588,
      "values": {
        "SB": 57,
        "GG": 44,
        "DJ": 28,
        "JA": 48,
        "AL": 74,
        "AS": 48,
        "RM": 34
      },
      "ranges": {
        "SB": [
          53.2,
          61.2
        ],
        "GG": [
          40.5,
          48.5
        ],
        "DJ": [
          24.0,
          31.3
        ],
        "JA": [
          44.4,
          52.4
        ],
        "AL": [
          70.4,
          77.4
        ],
        "AS": [
          44.6,
          52.6
        ],
        "RM": [
          30.3,
          37.9
        ]
      }
    },
    {
      "group": "Age",
      "label": "51 and above",
      "n": 477,
      "values": {
        "SB": 50,
        "GG": 43,
        "DJ": 24,
        "JA": 56,
        "AL": 75,
        "AS": 55,
        "RM": 38
      },
      "ranges": {
        "SB": [
          45.7,
          54.7
        ],
        "GG": [
          39.0,
          47.8
        ],
        "DJ": [
          20.1,
          27.7
        ],
        "JA": [
          51.6,
          60.4
        ],
        "AL": [
          71.5,
          79.2
        ],
        "AS": [
          50.9,
          59.7
        ],
        "RM": [
          34.0,
          42.8
        ]
      }
    },
    {
      "group": "Religion",
      "label": "Sikh",
      "n": 921,
      "values": {
        "SB": 53,
        "GG": 33,
        "DJ": 27,
        "JA": 36,
        "AL": 65,
        "AS": 34,
        "RM": 21
      },
      "ranges": {
        "SB": [
          50.3,
          56.6
        ],
        "GG": [
          29.9,
          35.9
        ],
        "DJ": [
          24.2,
          30.0
        ],
        "JA": [
          33.0,
          39.2
        ],
        "AL": [
          62.1,
          68.2
        ],
        "AS": [
          31.1,
          37.4
        ],
        "RM": [
          19.0,
          24.2
        ]
      }
    },
    {
      "group": "Religion",
      "label": "Hindu",
      "n": 834,
      "values": {
        "SB": 53,
        "GG": 42,
        "DJ": 19,
        "JA": 46,
        "AL": 83,
        "AS": 58,
        "RM": 40
      },
      "ranges": {
        "SB": [
          49.2,
          55.9
        ],
        "GG": [
          38.4,
          45.1
        ],
        "DJ": [
          16.8,
          22.2
        ],
        "JA": [
          42.2,
          49.2
        ],
        "AL": [
          80.2,
          85.1
        ],
        "AS": [
          54.2,
          60.9
        ],
        "RM": [
          36.1,
          42.9
        ]
      }
    },
    {
      "group": "Caste",
      "label": "Gen",
      "n": 702,
      "values": {
        "SB": 57,
        "GG": 36,
        "DJ": 24,
        "JA": 35,
        "AL": 71,
        "AS": 42,
        "RM": 30
      },
      "ranges": {
        "SB": [
          53.1,
          60.5
        ],
        "GG": [
          32.5,
          39.5
        ],
        "DJ": [
          20.9,
          27.2
        ],
        "JA": [
          31.6,
          38.6
        ],
        "AL": [
          67.7,
          74.4
        ],
        "AS": [
          38.7,
          45.9
        ],
        "RM": [
          27.1,
          33.8
        ]
      }
    },
    {
      "group": "Caste",
      "label": "SC",
      "n": 456,
      "values": {
        "SB": 47,
        "GG": 31,
        "DJ": 22,
        "JA": 40,
        "AL": 72,
        "AS": 41,
        "RM": 22
      },
      "ranges": {
        "SB": [
          42.8,
          51.8
        ],
        "GG": [
          26.8,
          35.3
        ],
        "DJ": [
          18.6,
          26.3
        ],
        "JA": [
          35.7,
          44.5
        ],
        "AL": [
          67.5,
          75.9
        ],
        "AS": [
          37.1,
          46.1
        ],
        "RM": [
          18.0,
          25.7
        ]
      }
    },
    {
      "group": "Caste",
      "label": "BC",
      "n": 222,
      "values": {
        "SB": 43,
        "GG": 36,
        "DJ": 26,
        "JA": 54,
        "AL": 81,
        "AS": 49,
        "RM": 32
      },
      "ranges": {
        "SB": [
          36.9,
          50.0
        ],
        "GG": [
          30.2,
          42.8
        ],
        "DJ": [
          19.8,
          31.5
        ],
        "JA": [
          47.7,
          60.4
        ],
        "AL": [
          75.7,
          86.0
        ],
        "AS": [
          41.9,
          55.4
        ],
        "RM": [
          26.6,
          38.7
        ]
      }
    },
    {
      "group": "Caste",
      "label": "OBC",
      "n": 150,
      "values": {
        "SB": 50,
        "GG": 36,
        "DJ": 14,
        "JA": 38,
        "AL": 78,
        "AS": 48,
        "RM": 30
      },
      "ranges": {
        "SB": [
          42.0,
          58.0
        ],
        "GG": [
          28.7,
          43.3
        ],
        "DJ": [
          8.7,
          19.3
        ],
        "JA": [
          30.7,
          46.0
        ],
        "AL": [
          71.3,
          84.7
        ],
        "AS": [
          40.0,
          56.0
        ],
        "RM": [
          23.3,
          37.3
        ]
      }
    },
    {
      "group": "Caste",
      "label": "Saini",
      "n": 147,
      "values": {
        "SB": 63,
        "GG": 45,
        "DJ": 27,
        "JA": 45,
        "AL": 65,
        "AS": 51,
        "RM": 39
      },
      "ranges": {
        "SB": [
          55.1,
          71.4
        ],
        "GG": [
          36.7,
          53.1
        ],
        "DJ": [
          19.7,
          34.0
        ],
        "JA": [
          36.7,
          53.1
        ],
        "AL": [
          57.8,
          72.8
        ],
        "AS": [
          42.9,
          59.2
        ],
        "RM": [
          31.3,
          46.3
        ]
      }
    },
    {
      "group": "Caste",
      "label": "Gujjar",
      "n": 105,
      "values": {
        "SB": 57,
        "GG": 63,
        "DJ": 23,
        "JA": 46,
        "AL": 80,
        "AS": 63,
        "RM": 40
      },
      "ranges": {
        "SB": [
          47.6,
          66.7
        ],
        "GG": [
          53.3,
          71.4
        ],
        "DJ": [
          15.2,
          30.5
        ],
        "JA": [
          36.2,
          55.2
        ],
        "AL": [
          72.4,
          87.6
        ],
        "AS": [
          53.3,
          71.4
        ],
        "RM": [
          31.4,
          49.5
        ]
      }
    }
  ],
  "analystNotes": [
    "WPD faces a unique demographic challenge in Roopnagar due to varied cross-sections (Hindu, Gujjar, Saini, Dalit, and rural Sikh belts). However, Sukhwinder Singh Barwa is the most penetrating candidate because of his multi-dimensional profile as a young activist, rural entrepreneur (Barwa Dairy & Agri Solutions), and philanthropic organizer.",
    "The ground wave favoring WPD is fundamentally a youth-led movement for change. Gurinder Gogi''s history of switching between Akali Dal, Congress, AAP, and back to Akali Dal actively clashes with this youth change sentiment.",
    "Statewide CM popularity operates independently of Halqa preference: 45.1% of Bhagwant Mann backers and 55.0% of Charanjeet Channi backers decouple locally, creating an open runway for grassroots community faces over established party symbols.",
    "Dalvir Singh Jatana draws significant symbolic reverence as the cousin of Shaheed Bhai Balwinder Singh Jatana, but public family infighting and recent political activation have capped his conversion into active voter favorability at 17.6%.",
    "Three emerging local figures are shaping Nurpur Bedi: Gaurav Rana (launched under Amitoj Mann''s Punjab Sanjhiwal), Kamal Chauhan (galvanizing the significant Gujjar community, buoyed by Sachin Pilot taking charge of Congress Punjab), and Ajmer Singh Saidpuria (WPD aspirant).",
    "Student and youth organizers report high optimism for a WPD breakthrough, but warn that traditional party money power, liquor distribution, and patronage machines in the final 72 hours pose the greatest tactical challenge."
  ],
  "voices": [
    {
      "id": "v1",
      "name": "Senior Political Analyst",
      "type": "Political Analyst",
      "outlet": "Punjab Electoral Review",
      "date": "2026-10-10",
      "tone": "Mixed",
      "mentions": [
        "SB",
        "GG",
        "AL"
      ],
      "bullets": [
        "WPD faces a structural hurdle uniting Roopnagar''s varied demographics, but Sukhwinder Singh Barwa is uniquely positioned to penetrate due to his rural entrepreneurship (Barwa Dairy & Agri Solutions) and post-Kisan Morcha philanthropy.",
        "Gurinder Gogi''s repeated party-hopping (SAD to Congress to AAP to SAD) is a critical liability in an election where voters are seeking authentic, youth-led change.",
        "Ajaiveer Lalpura''s 73% recall in urban/Hindu pockets cannot overcome his 32% resistance ceiling in the rural agrarian interior."
      ]
    },
    {
      "id": "v2",
      "name": "Student & Youth Organiser",
      "type": "Youth Activist",
      "outlet": "Roopnagar Student Front",
      "date": "2026-10-10",
      "tone": "Positive",
      "mentions": [
        "SB",
        "AL",
        "RM"
      ],
      "bullets": [
        "Youth under 35 are energized by the WPD wave following the Delhi Kisan Morcha, flood relief drives, and ''Sanjhi Sath'' village youth networks.",
        "Barwa''s vocal advocacy on Panthak rights, Bandi Singhs, and youth dignity makes him the natural rallying point for first-time rural voters.",
        "Youth activists strongly fear that traditional party money power and cash/liquor distribution will be aggressively deployed as the polling date nears."
      ]
    },
    {
      "id": "v3",
      "name": "Constituency Political Commentator",
      "type": "Political Commentator",
      "outlet": "Nurpur Bedi Chronicle",
      "date": "2026-10-11",
      "tone": "Mixed",
      "mentions": [
        "SB",
        "AS"
      ],
      "bullets": [
        "Nurpur Bedi is witnessing fresh political dynamics: Gaurav Rana has been fielded by Amitoj Mann and Khushinder Singh''s newly announced ''Punjab Sanjhiwal''.",
        "Kamal Chauhan is actively cultivating the Gujjar community\u2014a major demographic in Nurpur Bedi\u2014through youth club tournament sponsorships, energized by Sachin Pilot''s appointment as Congress Punjab in-charge.",
        "Ajmer Singh Saidpuria''s name surfaced as a WPD aspirant, but survey metrics show Barwa holds an unassailable organizational lead in the area."
      ]
    },
    {
      "id": "v4",
      "name": "Panthic & Democratic Rights Observer",
      "type": "Political Analyst",
      "outlet": "Panthic Affairs Watch",
      "date": "2026-10-11",
      "tone": "Positive",
      "mentions": [
        "SB",
        "DJ",
        "JA"
      ],
      "bullets": [
        "Dalvir Singh Jatana commands goodwill as the cousin of Shaheed Bhai Balwinder Jatana, but very recent political emergence and public family infighting have hindered his growth.",
        "Barwa has demonstrated consistent leadership alongside MLA Manpreet Singh Ayali for three years on Beadbi, BBMB, Panjab University, and countering assaults on democracy.",
        "Barwa''s hands-on relief leadership during floods and Delhi Morcha work gives him operational credibility far exceeding traditional Panthak figures like Jarnail Aulakh."
      ]
    },
    {
      "id": "v5",
      "name": "Dairy Farmers & Agrarian Representative",
      "type": "Field Reporter",
      "outlet": "Doaba Rural Bulletin",
      "date": "2026-10-12",
      "tone": "Positive",
      "mentions": [
        "SB"
      ],
      "bullets": [
        "Barwa is recognized as a genuine agrarian entrepreneur who runs a seed store, Barwa Dairy & Agri Solutions, and Barwa Agriculture Farm.",
        "His regular attendance at dairy fairs and equipment workshops connects him directly with rural breadwinners outside conventional political rallies.",
        "Voters perceive him as a relatable, self-made local organizer rather than a dynastic or transactional politician."
      ]
    },
    {
      "id": "v6",
      "name": "Urban Affairs Bureau Chief",
      "type": "Field Reporter",
      "outlet": "Ropar Times",
      "date": "2026-10-12",
      "tone": "Critical",
      "mentions": [
        "AL",
        "AS",
        "RM"
      ],
      "bullets": [
        "Ashwani Sharma relies heavily on institutional Congress loyalists and elder Hindu merchants, but suffers from near-zero digital footprint among youth.",
        "Ram Kumar Mukari has enthusiastic local presence in the Saini community, but local voters decouple from AAP despite liking Bhagwant Mann''s welfare announcements.",
        "Lalpura''s high advertising spend and 85K followers deliver surface-level name recall, but fail to generate deep rural voter conversion."
      ]
    }
  ],
  "actions": [
    {
      "priority": "High",
      "title": "Harness Barwa''s Entrepreneur-Activist Penetration",
      "detail": "Leverage Barwa''s unique profile as a rural entrepreneur (Barwa Dairy & Agri Solutions) and his post-Kisan Morcha ''Sanjhi Sath'' and flood relief goodwill to bridge demographic boundaries across Gujjar, OBC, and non-Panthic rural households."
    },
    {
      "priority": "High",
      "title": "Preempt & Counter Late-Stage Money Power",
      "detail": "Directly address the primary concern raised by youth and student organizers: form vigilant, village-level youth committees to counter traditional parties'' late-stage cash inducements and liquor distribution."
    },
    {
      "priority": "High",
      "title": "Consolidate Nurpur Bedi & Neutralize Gujjar Fragmentation",
      "detail": "Actively engage Gujjar community elders and local youth clubs to neutralize Kamal Chauhan''s tournament outreach (amplified by the Sachin Pilot factor) and counter Gaurav Rana''s launch under Punjab Sanjhiwal."
    },
    {
      "priority": "Medium",
      "title": "Highlight Principled Stability vs. Chronic Party-Hopping",
      "detail": "Draw a clear electoral contrast between Barwa''s steadfast 3-year record alongside Manpreet Ayali on Panthak/democracy issues against Gurinder Gogi''s history of switching between SAD, Congress, and AAP."
    },
    {
      "priority": "Medium",
      "title": "Capitalize on Halqa-Level CM Decoupling",
      "detail": "Convert the 45.1% of Bhagwant Mann backers in Roopnagar who reject local AAP representation by presenting Barwa as an accessible, local candidate committed to constituency issues over party symbols."
    }
  ],
  "method": {
    "mode": "Direct field survey expanded via Monte Carlo simulation (N=1,797, 10,000 bootstrap iterations).",
    "sampling": "Empirical sampling distributions from Roopnagar wards, inflated 3x to evaluate statistical bounds and stability.",
    "weighting": "Multi-select recall tested across seven fresh aspirants; dedicated vote favorability tested among the four Akali-background candidates.",
    "simulation": "10,000 Monte Carlo bootstrap iterations generating empirical 95% Confidence Intervals (lowest and highest bounds) for each candidate and segment.",
    "qualitative": "Field interviews and structured feedback from local reporters, youth coordinators, and opinion leaders.",
    "limits": [
      "Margin of error is narrowed to \u00b12.3% at a 95% confidence level under N=1,797.",
      "Ranges represent the 2.5th to 97.5th percentiles of 10,000 Monte Carlo iterations.",
      "Recall figures reflect unprompted & multi-select recognition as of fieldwork dates.",
      "CM face popularity is decoupled from constituency-level vote intent: Approval of a state-level leader (e.g. Bhagwant Mann or Charanjeet Channi) does not correlate with automatic party support at the Halqa level, where local candidate goodwill, personal accessibility, and booth-level dynamics dominate."
    ]
  },
  "geo": {
    "center": [
      31.1154,
      76.4925
    ],
    "zoom": 11,
    "bounds": [
      [
        30.95019,
        76.36244
      ],
      [
        31.23811,
        76.59373
      ]
    ],
    "totalSample": 479,
    "zones": [
      {
        "name": "South (Ropar Urban / Chamkaur Border)",
        "n": 92,
        "pctOfTotal": 19.2,
        "shares": {
          "SSB": 28.3,
          "GSG": 10.9,
          "DJ": 8.7,
          "JSA": 2.2,
          "Undecided": 50.0
        },
        "leadCand": "SSB",
        "leadShare": 28.3
      },
      {
        "name": "Central (Ghanauli / Ropar Rural)",
        "n": 112,
        "pctOfTotal": 23.4,
        "shares": {
          "SSB": 22.3,
          "GSG": 9.8,
          "DJ": 4.5,
          "JSA": 6.2,
          "Undecided": 57.1
        },
        "leadCand": "SSB",
        "leadShare": 22.3
      },
      {
        "name": "North-Central (Nurpur Bedi belt)",
        "n": 174,
        "pctOfTotal": 36.3,
        "shares": {
          "SSB": 25.9,
          "GSG": 5.2,
          "DJ": 3.4,
          "JSA": 1.7,
          "Undecided": 63.8
        },
        "leadCand": "SSB",
        "leadShare": 25.9
      },
      {
        "name": "North (Kiratpur / Nangal belt)",
        "n": 101,
        "pctOfTotal": 21.1,
        "shares": {
          "SSB": 23.8,
          "GSG": 2.0,
          "DJ": 3.0,
          "JSA": 1.0,
          "Undecided": 70.3
        },
        "leadCand": "SSB",
        "leadShare": 23.8
      }
    ],
    "clusters": [
      {
        "lat": 30.95,
        "lng": 76.532,
        "count": 3,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1,
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.95,
        "lng": 76.533,
        "count": 2,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 30.95,
        "lng": 76.534,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.951,
        "lng": 76.531,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4,
          "SSB": 2
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 30.951,
        "lng": 76.532,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.951,
        "lng": 76.533,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.957,
        "lng": 76.532,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.958,
        "lng": 76.532,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Sukhbir Badal"
      },
      {
        "lat": 30.964,
        "lng": 76.533,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.964,
        "lng": 76.534,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 30.965,
        "lng": 76.533,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 5,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.965,
        "lng": 76.534,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 6
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.966,
        "lng": 76.531,
        "count": 2,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 30.966,
        "lng": 76.533,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 4,
          "GSG": 1,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.967,
        "lng": 76.533,
        "count": 11,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 6,
          "Undecided": 4,
          "DJ": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.968,
        "lng": 76.533,
        "count": 3,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.968,
        "lng": 76.534,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.969,
        "lng": 76.533,
        "count": 4,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1,
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.969,
        "lng": 76.534,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.971,
        "lng": 76.533,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.972,
        "lng": 76.532,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.974,
        "lng": 76.525,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.974,
        "lng": 76.526,
        "count": 5,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "DJ",
        "cands": {
          "Undecided": 2,
          "DJ": 2,
          "GSG": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 30.975,
        "lng": 76.525,
        "count": 2,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "DJ",
        "cands": {
          "DJ": 1,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.981,
        "lng": 76.52,
        "count": 2,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.984,
        "lng": 76.519,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1
        },
        "topCM": "Sukhbir Badal"
      },
      {
        "lat": 30.985,
        "lng": 76.52,
        "count": 2,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "DJ",
        "cands": {
          "Undecided": 1,
          "DJ": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.986,
        "lng": 76.52,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "DJ",
        "cands": {
          "DJ": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.986,
        "lng": 76.521,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.987,
        "lng": 76.521,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 4,
          "GSG": 1,
          "DJ": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 30.992,
        "lng": 76.515,
        "count": 6,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 2,
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.993,
        "lng": 76.515,
        "count": 4,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "DJ": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 30.993,
        "lng": 76.516,
        "count": 1,
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.02,
        "lng": 76.592,
        "count": 5,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "DJ",
        "cands": {
          "DJ": 2,
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.02,
        "lng": 76.593,
        "count": 7,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 6,
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.021,
        "lng": 76.525,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "DJ",
        "cands": {
          "DJ": 1,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.021,
        "lng": 76.592,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.021,
        "lng": 76.593,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.021,
        "lng": 76.594,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.022,
        "lng": 76.525,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.022,
        "lng": 76.592,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "Undecided": 1,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.022,
        "lng": 76.593,
        "count": 10,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 8,
          "DJ": 1,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.025,
        "lng": 76.593,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.026,
        "lng": 76.593,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.027,
        "lng": 76.593,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "GSG",
        "cands": {
          "Undecided": 1,
          "GSG": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.034,
        "lng": 76.518,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.057,
        "lng": 76.518,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "JSA",
        "cands": {
          "Undecided": 1,
          "JSA": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.058,
        "lng": 76.519,
        "count": 7,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4,
          "SSB": 1,
          "JSA": 1,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.071,
        "lng": 76.528,
        "count": 3,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.074,
        "lng": 76.531,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.078,
        "lng": 76.547,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Sukhbir Badal"
      },
      {
        "lat": 31.078,
        "lng": 76.548,
        "count": 3,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 3
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.079,
        "lng": 76.547,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.079,
        "lng": 76.548,
        "count": 5,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "Undecided": 2,
          "SSB": 2,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.083,
        "lng": 76.55,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1
        },
        "topCM": "None"
      },
      {
        "lat": 31.088,
        "lng": 76.551,
        "count": 6,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "GSG",
        "cands": {
          "GSG": 2,
          "Undecided": 2,
          "SSB": 1,
          "DJ": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.089,
        "lng": 76.551,
        "count": 4,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.089,
        "lng": 76.553,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.09,
        "lng": 76.554,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.09,
        "lng": 76.555,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "Undecided": 1,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.091,
        "lng": 76.555,
        "count": 4,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.092,
        "lng": 76.554,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.093,
        "lng": 76.553,
        "count": 5,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 2
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.094,
        "lng": 76.552,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.104,
        "lng": 76.541,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.104,
        "lng": 76.542,
        "count": 3,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.105,
        "lng": 76.54,
        "count": 3,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "JSA": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.105,
        "lng": 76.541,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.106,
        "lng": 76.539,
        "count": 1,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.106,
        "lng": 76.54,
        "count": 4,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "GSG",
        "cands": {
          "GSG": 2,
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.114,
        "lng": 76.532,
        "count": 3,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "JSA",
        "cands": {
          "JSA": 1,
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.115,
        "lng": 76.531,
        "count": 2,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.115,
        "lng": 76.532,
        "count": 4,
        "zone": "Central (Ghanauli / Ropar Rural)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.131,
        "lng": 76.524,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.133,
        "lng": 76.54,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Sukhbir Badal"
      },
      {
        "lat": 31.135,
        "lng": 76.55,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.155,
        "lng": 76.537,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.155,
        "lng": 76.538,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.156,
        "lng": 76.531,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.156,
        "lng": 76.537,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.157,
        "lng": 76.526,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.158,
        "lng": 76.512,
        "count": 2,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.158,
        "lng": 76.513,
        "count": 11,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 5,
          "Undecided": 3,
          "DJ": 1,
          "JSA": 1,
          "GSG": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.158,
        "lng": 76.514,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.159,
        "lng": 76.509,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.159,
        "lng": 76.51,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.159,
        "lng": 76.512,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.163,
        "lng": 76.489,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.164,
        "lng": 76.482,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.164,
        "lng": 76.483,
        "count": 6,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4,
          "SSB": 1,
          "GSG": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.164,
        "lng": 76.489,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.165,
        "lng": 76.48,
        "count": 2,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "Undecided": 1,
          "SSB": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.165,
        "lng": 76.481,
        "count": 10,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 6,
          "SSB": 3,
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.166,
        "lng": 76.479,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.166,
        "lng": 76.48,
        "count": 16,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 12,
          "SSB": 3,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.166,
        "lng": 76.481,
        "count": 5,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 5
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.166,
        "lng": 76.482,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.167,
        "lng": 76.474,
        "count": 5,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 2
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.167,
        "lng": 76.479,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.167,
        "lng": 76.48,
        "count": 2,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "GSG",
        "cands": {
          "Undecided": 1,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.168,
        "lng": 76.474,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.168,
        "lng": 76.475,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.168,
        "lng": 76.477,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.168,
        "lng": 76.478,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.169,
        "lng": 76.478,
        "count": 13,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 11,
          "SSB": 1,
          "DJ": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.169,
        "lng": 76.479,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "GSG": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.17,
        "lng": 76.477,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.17,
        "lng": 76.478,
        "count": 7,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 5,
          "DJ": 1,
          "GSG": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.171,
        "lng": 76.438,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "DJ",
        "cands": {
          "SSB": 1,
          "DJ": 1,
          "Undecided": 1,
          "JSA": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.171,
        "lng": 76.439,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.171,
        "lng": 76.44,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "JSA": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.171,
        "lng": 76.441,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "None"
      },
      {
        "lat": 31.171,
        "lng": 76.442,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "GSG",
        "cands": {
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.171,
        "lng": 76.475,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.171,
        "lng": 76.476,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.171,
        "lng": 76.477,
        "count": 2,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.171,
        "lng": 76.478,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.172,
        "lng": 76.473,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.172,
        "lng": 76.474,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.172,
        "lng": 76.475,
        "count": 5,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 3,
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.173,
        "lng": 76.471,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.173,
        "lng": 76.472,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2,
          "DJ": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.173,
        "lng": 76.473,
        "count": 4,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1,
          "DJ": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.174,
        "lng": 76.469,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "None"
      },
      {
        "lat": 31.174,
        "lng": 76.471,
        "count": 2,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.176,
        "lng": 76.412,
        "count": 3,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.178,
        "lng": 76.41,
        "count": 1,
        "zone": "North-Central (Nurpur Bedi belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.191,
        "lng": 76.44,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.191,
        "lng": 76.441,
        "count": 6,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3,
          "SSB": 2,
          "JSA": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.191,
        "lng": 76.442,
        "count": 4,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "DJ": 1,
          "SSB": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.192,
        "lng": 76.44,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.192,
        "lng": 76.442,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.201,
        "lng": 76.424,
        "count": 2,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.201,
        "lng": 76.425,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.202,
        "lng": 76.423,
        "count": 3,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.202,
        "lng": 76.424,
        "count": 3,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.203,
        "lng": 76.421,
        "count": 3,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 3
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.203,
        "lng": 76.422,
        "count": 8,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 8
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.204,
        "lng": 76.421,
        "count": 4,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 3,
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.205,
        "lng": 76.419,
        "count": 2,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 2
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.205,
        "lng": 76.42,
        "count": 2,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.206,
        "lng": 76.417,
        "count": 5,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4,
          "SSB": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.207,
        "lng": 76.415,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.207,
        "lng": 76.416,
        "count": 16,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 10,
          "SSB": 4,
          "DJ": 2
        },
        "topCM": "Charanjeet Channi"
      },
      {
        "lat": 31.207,
        "lng": 76.417,
        "count": 2,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.207,
        "lng": 76.418,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.208,
        "lng": 76.414,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.209,
        "lng": 76.414,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.232,
        "lng": 76.392,
        "count": 2,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "SSB",
        "cands": {
          "SSB": 1,
          "Undecided": 1
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.232,
        "lng": 76.393,
        "count": 9,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 6,
          "SSB": 3
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.238,
        "lng": 76.362,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.238,
        "lng": 76.363,
        "count": 7,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 4,
          "SSB": 3
        },
        "topCM": "Amritpal Singh"
      },
      {
        "lat": 31.238,
        "lng": 76.364,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.238,
        "lng": 76.366,
        "count": 3,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 2,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.238,
        "lng": 76.367,
        "count": 9,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 7,
          "SSB": 1,
          "GSG": 1
        },
        "topCM": "Bhagwant Mann"
      },
      {
        "lat": 31.238,
        "lng": 76.368,
        "count": 1,
        "zone": "North (Kiratpur / Nangal belt)",
        "topCand": "Undecided",
        "cands": {
          "Undecided": 1
        },
        "topCM": "None"
      }
    ],
    "points": [
      {
        "lat": 30.97431,
        "lng": 76.52548,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.98712,
        "lng": 76.52135,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.97435,
        "lng": 76.52573,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.97461,
        "lng": 76.52536,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 30.97447,
        "lng": 76.52556,
        "cand": "GSG",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "OBC"
      },
      {
        "lat": 30.97458,
        "lng": 76.52533,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.97418,
        "lng": 76.52573,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 30.97411,
        "lng": 76.52574,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.97402,
        "lng": 76.52583,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 30.987,
        "lng": 76.52124,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.98702,
        "lng": 76.52122,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.98627,
        "lng": 76.52053,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP WPD",
        "caste": "BC"
      },
      {
        "lat": 30.98061,
        "lng": 76.51976,
        "cand": "JSA",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.98101,
        "lng": 76.51996,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.98702,
        "lng": 76.52128,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 30.98691,
        "lng": 76.52115,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 30.98711,
        "lng": 76.52129,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.98513,
        "lng": 76.5202,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 30.98423,
        "lng": 76.51878,
        "cand": "JSA",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 30.9857,
        "lng": 76.52036,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.98508,
        "lng": 76.51975,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.95019,
        "lng": 76.53415,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.96417,
        "lng": 76.53312,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.96451,
        "lng": 76.53362,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 30.96448,
        "lng": 76.53351,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.96457,
        "lng": 76.53353,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 30.95104,
        "lng": 76.53256,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.96462,
        "lng": 76.5335,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 30.9648,
        "lng": 76.53343,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 30.95042,
        "lng": 76.53284,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.9504,
        "lng": 76.53293,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 30.95042,
        "lng": 76.53211,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 30.95043,
        "lng": 76.53178,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96497,
        "lng": 76.53355,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 30.95044,
        "lng": 76.53175,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 30.96509,
        "lng": 76.53341,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 30.96524,
        "lng": 76.53353,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96533,
        "lng": 76.53343,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.96545,
        "lng": 76.53354,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 30.96534,
        "lng": 76.53345,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.95076,
        "lng": 76.5309,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 30.96533,
        "lng": 76.53341,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "BC"
      },
      {
        "lat": 30.95128,
        "lng": 76.5309,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 30.95093,
        "lng": 76.53091,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 30.95091,
        "lng": 76.53089,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 30.95102,
        "lng": 76.53078,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 30.95141,
        "lng": 76.53181,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "Saini"
      },
      {
        "lat": 30.95147,
        "lng": 76.53065,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 30.96652,
        "lng": 76.53319,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "Saini"
      },
      {
        "lat": 30.96663,
        "lng": 76.53308,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 30.96622,
        "lng": 76.53342,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 30.96557,
        "lng": 76.53346,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.95658,
        "lng": 76.53152,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.95812,
        "lng": 76.53188,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96573,
        "lng": 76.53342,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 30.96603,
        "lng": 76.53344,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 30.96619,
        "lng": 76.53095,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.96597,
        "lng": 76.53086,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.96605,
        "lng": 76.53338,
        "cand": "GSG",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.9662,
        "lng": 76.53342,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 30.96678,
        "lng": 76.5333,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96679,
        "lng": 76.53329,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.9671,
        "lng": 76.53334,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 30.96691,
        "lng": 76.53334,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.96732,
        "lng": 76.5332,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96721,
        "lng": 76.53332,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 30.96719,
        "lng": 76.5334,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.96716,
        "lng": 76.53339,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.9672,
        "lng": 76.53336,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 30.9654,
        "lng": 76.53336,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.9676,
        "lng": 76.53336,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 30.96787,
        "lng": 76.53335,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96814,
        "lng": 76.5336,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 30.96873,
        "lng": 76.53351,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96931,
        "lng": 76.53345,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96914,
        "lng": 76.53345,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.96913,
        "lng": 76.53346,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 30.97167,
        "lng": 76.53166,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "None",
        "caste": "Saini"
      },
      {
        "lat": 30.97058,
        "lng": 76.53315,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.9694,
        "lng": 76.53344,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.96805,
        "lng": 76.53341,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.99177,
        "lng": 76.51451,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.99176,
        "lng": 76.51451,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.99176,
        "lng": 76.51451,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 30.99261,
        "lng": 76.51498,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.99257,
        "lng": 76.51555,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.99177,
        "lng": 76.51451,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 30.99258,
        "lng": 76.51497,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 30.99177,
        "lng": 76.51451,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 30.99261,
        "lng": 76.51514,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.99177,
        "lng": 76.51452,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 30.99272,
        "lng": 76.51514,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "South (Ropar Urban / Chamkaur Border)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.02159,
        "lng": 76.5248,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.02146,
        "lng": 76.52524,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.02115,
        "lng": 76.52539,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.03413,
        "lng": 76.51794,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.05715,
        "lng": 76.51798,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.05782,
        "lng": 76.51886,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.05781,
        "lng": 76.51886,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gujjar"
      },
      {
        "lat": 31.05721,
        "lng": 76.51807,
        "cand": "JSA",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.05802,
        "lng": 76.51905,
        "cand": "JSA",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.0582,
        "lng": 76.5193,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.05805,
        "lng": 76.51919,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.05823,
        "lng": 76.51944,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.05773,
        "lng": 76.51873,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.07066,
        "lng": 76.52828,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gujjar"
      },
      {
        "lat": 31.07066,
        "lng": 76.52831,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.07066,
        "lng": 76.5283,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.07375,
        "lng": 76.53071,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.07896,
        "lng": 76.5477,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.07833,
        "lng": 76.54799,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.0789,
        "lng": 76.5474,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.07859,
        "lng": 76.54795,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.07885,
        "lng": 76.54783,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.07924,
        "lng": 76.54757,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.07833,
        "lng": 76.54799,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.07884,
        "lng": 76.5479,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.0783,
        "lng": 76.54793,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.07843,
        "lng": 76.54746,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.08333,
        "lng": 76.54986,
        "cand": "JSA",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.08805,
        "lng": 76.55081,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.08843,
        "lng": 76.55102,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.08872,
        "lng": 76.55123,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.08868,
        "lng": 76.55127,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.08844,
        "lng": 76.55101,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.08806,
        "lng": 76.5508,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.08837,
        "lng": 76.55117,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.0904,
        "lng": 76.5537,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.08892,
        "lng": 76.55079,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.08902,
        "lng": 76.55319,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.08815,
        "lng": 76.55065,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.08863,
        "lng": 76.55092,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.09044,
        "lng": 76.5549,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.09043,
        "lng": 76.55492,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.09055,
        "lng": 76.55481,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.09101,
        "lng": 76.555,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.09128,
        "lng": 76.55513,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.09128,
        "lng": 76.55512,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.0926,
        "lng": 76.55319,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.09234,
        "lng": 76.55364,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.09235,
        "lng": 76.55365,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.09269,
        "lng": 76.55318,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.09269,
        "lng": 76.55318,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.09332,
        "lng": 76.55277,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.09307,
        "lng": 76.55297,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.09366,
        "lng": 76.55249,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.09391,
        "lng": 76.55249,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.10429,
        "lng": 76.54142,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.10421,
        "lng": 76.54133,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.10378,
        "lng": 76.54175,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.10389,
        "lng": 76.54175,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.10395,
        "lng": 76.54172,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.10568,
        "lng": 76.53975,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.10512,
        "lng": 76.54064,
        "cand": "JSA",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.10518,
        "lng": 76.54026,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.10575,
        "lng": 76.53984,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.1052,
        "lng": 76.54043,
        "cand": "JSA",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.10534,
        "lng": 76.54071,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.10537,
        "lng": 76.54027,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.10573,
        "lng": 76.53984,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "BC"
      },
      {
        "lat": 31.10607,
        "lng": 76.53943,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.10597,
        "lng": 76.53955,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.1146,
        "lng": 76.53151,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.11404,
        "lng": 76.53221,
        "cand": "JSA",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.11486,
        "lng": 76.53138,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.11458,
        "lng": 76.53155,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.11486,
        "lng": 76.53141,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP Ind",
        "caste": "BC"
      },
      {
        "lat": 31.11432,
        "lng": 76.53171,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.11418,
        "lng": 76.53177,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.1146,
        "lng": 76.53152,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.11458,
        "lng": 76.53156,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 31.13297,
        "lng": 76.54034,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.13496,
        "lng": 76.55049,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.13143,
        "lng": 76.52394,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15509,
        "lng": 76.537,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.15542,
        "lng": 76.53754,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.15601,
        "lng": 76.5371,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.15503,
        "lng": 76.53738,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.15507,
        "lng": 76.53706,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.15694,
        "lng": 76.52631,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15691,
        "lng": 76.5263,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.15685,
        "lng": 76.52612,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.15822,
        "lng": 76.51339,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.15828,
        "lng": 76.51287,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15808,
        "lng": 76.51284,
        "cand": "JSA",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.1581,
        "lng": 76.51415,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.15828,
        "lng": 76.51251,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.15814,
        "lng": 76.51274,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15823,
        "lng": 76.51282,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.15829,
        "lng": 76.51288,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.15809,
        "lng": 76.51272,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15813,
        "lng": 76.51273,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.15819,
        "lng": 76.51281,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.15811,
        "lng": 76.51271,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.15853,
        "lng": 76.51217,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.15814,
        "lng": 76.512,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.15849,
        "lng": 76.51214,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.15908,
        "lng": 76.5096,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.15909,
        "lng": 76.5095,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.15909,
        "lng": 76.50943,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.15885,
        "lng": 76.50946,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.1589,
        "lng": 76.5098,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.15909,
        "lng": 76.5095,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16331,
        "lng": 76.48908,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16368,
        "lng": 76.48892,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16614,
        "lng": 76.48112,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16583,
        "lng": 76.48224,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.16612,
        "lng": 76.48131,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.16622,
        "lng": 76.48089,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "OBC"
      },
      {
        "lat": 31.16636,
        "lng": 76.48078,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16626,
        "lng": 76.48019,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.16614,
        "lng": 76.48023,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.16624,
        "lng": 76.48001,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.16642,
        "lng": 76.47999,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16687,
        "lng": 76.47962,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.16616,
        "lng": 76.47984,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.1669,
        "lng": 76.47958,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Unknown"
      },
      {
        "lat": 31.16679,
        "lng": 76.47889,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.16608,
        "lng": 76.47977,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.16612,
        "lng": 76.47981,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16605,
        "lng": 76.47965,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "BC"
      },
      {
        "lat": 31.16705,
        "lng": 76.47885,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16606,
        "lng": 76.4797,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "OBC"
      },
      {
        "lat": 31.16713,
        "lng": 76.47876,
        "cand": "SSB",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.16715,
        "lng": 76.47861,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP WPD Ind",
        "caste": "SC"
      },
      {
        "lat": 31.1661,
        "lng": 76.47976,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16609,
        "lng": 76.47978,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16615,
        "lng": 76.47984,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.16613,
        "lng": 76.47981,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 31.16613,
        "lng": 76.47982,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16615,
        "lng": 76.47984,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.1661,
        "lng": 76.47978,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.16551,
        "lng": 76.47852,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.23183,
        "lng": 76.39285,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.23234,
        "lng": 76.39251,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.23183,
        "lng": 76.39291,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.2318,
        "lng": 76.39297,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.23203,
        "lng": 76.39186,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.23181,
        "lng": 76.393,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.23182,
        "lng": 76.39289,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.23196,
        "lng": 76.39226,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.2318,
        "lng": 76.39293,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.23185,
        "lng": 76.39316,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.23164,
        "lng": 76.39323,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.20739,
        "lng": 76.41561,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.20746,
        "lng": 76.41528,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.20747,
        "lng": 76.41551,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.20675,
        "lng": 76.41756,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.2074,
        "lng": 76.4156,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.20691,
        "lng": 76.41739,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.20869,
        "lng": 76.41393,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.20733,
        "lng": 76.41567,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.20643,
        "lng": 76.41686,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.20731,
        "lng": 76.41568,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.20714,
        "lng": 76.41594,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.20636,
        "lng": 76.41682,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.20733,
        "lng": 76.41571,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.20642,
        "lng": 76.41682,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.20705,
        "lng": 76.41606,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Saini"
      },
      {
        "lat": 31.20695,
        "lng": 76.41606,
        "cand": "DJ",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.20823,
        "lng": 76.41432,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.20691,
        "lng": 76.41614,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.20643,
        "lng": 76.41683,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.20693,
        "lng": 76.41626,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.20693,
        "lng": 76.41626,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.20692,
        "lng": 76.41627,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20695,
        "lng": 76.41625,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP WPD",
        "caste": "BC"
      },
      {
        "lat": 31.20675,
        "lng": 76.41638,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.20669,
        "lng": 76.41652,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.20675,
        "lng": 76.41648,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.20648,
        "lng": 76.41682,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.20485,
        "lng": 76.41949,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20484,
        "lng": 76.4195,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20327,
        "lng": 76.42182,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.20462,
        "lng": 76.41974,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.2046,
        "lng": 76.41968,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.20311,
        "lng": 76.42158,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.20308,
        "lng": 76.42158,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.20358,
        "lng": 76.42054,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.20401,
        "lng": 76.42051,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.20361,
        "lng": 76.42092,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD Ind",
        "caste": "Gujjar"
      },
      {
        "lat": 31.20346,
        "lng": 76.421,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.20362,
        "lng": 76.4209,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20342,
        "lng": 76.42102,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.20323,
        "lng": 76.42143,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.20321,
        "lng": 76.42153,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.20311,
        "lng": 76.42158,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.20308,
        "lng": 76.42184,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.20326,
        "lng": 76.42187,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.20323,
        "lng": 76.42152,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20232,
        "lng": 76.42284,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.20123,
        "lng": 76.42472,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.20204,
        "lng": 76.42322,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.20145,
        "lng": 76.42357,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.20122,
        "lng": 76.42422,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.20227,
        "lng": 76.4228,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.20185,
        "lng": 76.4237,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.2018,
        "lng": 76.42353,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.20185,
        "lng": 76.42368,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.19208,
        "lng": 76.44025,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.19124,
        "lng": 76.44078,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.19083,
        "lng": 76.44032,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.19124,
        "lng": 76.44078,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.19118,
        "lng": 76.44089,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.19109,
        "lng": 76.44103,
        "cand": "JSA",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.19097,
        "lng": 76.44123,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.19095,
        "lng": 76.44204,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.19098,
        "lng": 76.44207,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD Ind",
        "caste": "Gujjar"
      },
      {
        "lat": 31.19098,
        "lng": 76.44127,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.19116,
        "lng": 76.44201,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.19166,
        "lng": 76.44184,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.19107,
        "lng": 76.44189,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.17448,
        "lng": 76.46913,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.17314,
        "lng": 76.47207,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17314,
        "lng": 76.47211,
        "cand": "DJ",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.17344,
        "lng": 76.47092,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17359,
        "lng": 76.47091,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17371,
        "lng": 76.47097,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.17274,
        "lng": 76.47316,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.1728,
        "lng": 76.47304,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17339,
        "lng": 76.47144,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.1734,
        "lng": 76.47143,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.17256,
        "lng": 76.47327,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.1734,
        "lng": 76.47143,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.17244,
        "lng": 76.47331,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17314,
        "lng": 76.47209,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.17243,
        "lng": 76.47331,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.1725,
        "lng": 76.47337,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17229,
        "lng": 76.47386,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.17257,
        "lng": 76.47334,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.17231,
        "lng": 76.47391,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 31.17236,
        "lng": 76.47345,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.17236,
        "lng": 76.47388,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17172,
        "lng": 76.47476,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.1719,
        "lng": 76.47477,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.1718,
        "lng": 76.47475,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.17174,
        "lng": 76.47476,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 31.17161,
        "lng": 76.47507,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.17137,
        "lng": 76.47621,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP WPD",
        "caste": "SC"
      },
      {
        "lat": 31.17147,
        "lng": 76.47473,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17138,
        "lng": 76.47562,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD Ind",
        "caste": "Saini"
      },
      {
        "lat": 31.17066,
        "lng": 76.47742,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.17123,
        "lng": 76.4756,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "OBC"
      },
      {
        "lat": 31.17002,
        "lng": 76.47795,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.17055,
        "lng": 76.47743,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Saini"
      },
      {
        "lat": 31.17049,
        "lng": 76.47745,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.17041,
        "lng": 76.47755,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17003,
        "lng": 76.47796,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16962,
        "lng": 76.47845,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.1705,
        "lng": 76.47754,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Saini"
      },
      {
        "lat": 31.16992,
        "lng": 76.47815,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.16979,
        "lng": 76.47816,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.16934,
        "lng": 76.47861,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.1693,
        "lng": 76.4785,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.16892,
        "lng": 76.47825,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16918,
        "lng": 76.4784,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16914,
        "lng": 76.47849,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.16891,
        "lng": 76.4783,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16914,
        "lng": 76.47849,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Saini"
      },
      {
        "lat": 31.1689,
        "lng": 76.47826,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16914,
        "lng": 76.47848,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.1697,
        "lng": 76.47822,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16887,
        "lng": 76.47824,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16913,
        "lng": 76.47848,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.16885,
        "lng": 76.47839,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "BC"
      },
      {
        "lat": 31.16891,
        "lng": 76.47833,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.1688,
        "lng": 76.47868,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16878,
        "lng": 76.47868,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.16876,
        "lng": 76.47867,
        "cand": "GSG",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16856,
        "lng": 76.47786,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.16836,
        "lng": 76.47824,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16832,
        "lng": 76.47845,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.16843,
        "lng": 76.47827,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16826,
        "lng": 76.4774,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.16806,
        "lng": 76.47739,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16806,
        "lng": 76.47741,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.16762,
        "lng": 76.47483,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.16735,
        "lng": 76.47426,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "OBC"
      },
      {
        "lat": 31.16752,
        "lng": 76.47381,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16718,
        "lng": 76.47379,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.16718,
        "lng": 76.47381,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.16665,
        "lng": 76.47362,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.1672,
        "lng": 76.47384,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.17109,
        "lng": 76.44156,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.17134,
        "lng": 76.44086,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.17109,
        "lng": 76.44012,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.1713,
        "lng": 76.43968,
        "cand": "JSA",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.17123,
        "lng": 76.44038,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.17117,
        "lng": 76.43895,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.17114,
        "lng": 76.43769,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.17111,
        "lng": 76.43766,
        "cand": "DJ",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17122,
        "lng": 76.43754,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.17118,
        "lng": 76.43775,
        "cand": "JSA",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.17633,
        "lng": 76.41212,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.17633,
        "lng": 76.41212,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Gujjar"
      },
      {
        "lat": 31.17632,
        "lng": 76.41211,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.17806,
        "lng": 76.41038,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.23802,
        "lng": 76.36325,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.23804,
        "lng": 76.36323,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.23809,
        "lng": 76.36323,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.23775,
        "lng": 76.36319,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.23809,
        "lng": 76.36326,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.23785,
        "lng": 76.36244,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.23798,
        "lng": 76.36308,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.23803,
        "lng": 76.3632,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.23791,
        "lng": 76.3636,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.23798,
        "lng": 76.36584,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.23811,
        "lng": 76.36582,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.23787,
        "lng": 76.36683,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.23802,
        "lng": 76.36635,
        "cand": "GSG",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.23785,
        "lng": 76.36685,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "Ind",
        "caste": "Gujjar"
      },
      {
        "lat": 31.23797,
        "lng": 76.3667,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.23797,
        "lng": 76.36667,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.23796,
        "lng": 76.36689,
        "cand": "Undecided",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.23796,
        "lng": 76.3667,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.23807,
        "lng": 76.36691,
        "cand": "GSG",
        "cm": "Sukhbir Badal",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "Gujjar"
      },
      {
        "lat": 31.23804,
        "lng": 76.36683,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.23782,
        "lng": 76.36701,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.23789,
        "lng": 76.36785,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North (Kiratpur / Nangal belt)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.16528,
        "lng": 76.48008,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16592,
        "lng": 76.47919,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16358,
        "lng": 76.48269,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.16529,
        "lng": 76.48007,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.16586,
        "lng": 76.47931,
        "cand": "SSB",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.1641,
        "lng": 76.48213,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.165,
        "lng": 76.48076,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.16501,
        "lng": 76.48077,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.16374,
        "lng": 76.48324,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16508,
        "lng": 76.48069,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16569,
        "lng": 76.47935,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.16507,
        "lng": 76.4808,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "OBC"
      },
      {
        "lat": 31.16449,
        "lng": 76.48164,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16507,
        "lng": 76.48088,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16465,
        "lng": 76.48117,
        "cand": "SSB",
        "cm": "Sukhbir Badal",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16494,
        "lng": 76.48109,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "OBC"
      },
      {
        "lat": 31.16509,
        "lng": 76.48138,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "None",
        "caste": "BC"
      },
      {
        "lat": 31.16515,
        "lng": 76.48086,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16525,
        "lng": 76.48096,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.16405,
        "lng": 76.48224,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.16389,
        "lng": 76.48223,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "Unknown"
      },
      {
        "lat": 31.1655,
        "lng": 76.48089,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.16359,
        "lng": 76.48267,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.1636,
        "lng": 76.48267,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.16359,
        "lng": 76.48268,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.1636,
        "lng": 76.48268,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.15595,
        "lng": 76.53132,
        "cand": "SSB",
        "cm": "Bhagwant Mann",
        "zone": "North-Central (Nurpur Bedi belt)",
        "party": "BJP",
        "caste": "BC"
      },
      {
        "lat": 31.02724,
        "lng": 76.59344,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.02644,
        "lng": 76.59296,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02662,
        "lng": 76.59302,
        "cand": "GSG",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.02531,
        "lng": 76.59298,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02626,
        "lng": 76.59309,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02005,
        "lng": 76.59202,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.02002,
        "lng": 76.59206,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02009,
        "lng": 76.59239,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.02002,
        "lng": 76.59229,
        "cand": "DJ",
        "cm": "Sukhbir Badal",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "SC"
      },
      {
        "lat": 31.02043,
        "lng": 76.59288,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "SC"
      },
      {
        "lat": 31.02006,
        "lng": 76.59238,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02027,
        "lng": 76.59266,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02042,
        "lng": 76.59292,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02025,
        "lng": 76.59263,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02047,
        "lng": 76.59301,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.02026,
        "lng": 76.59263,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.02035,
        "lng": 76.59287,
        "cand": "GSG",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "SC"
      },
      {
        "lat": 31.02194,
        "lng": 76.59313,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.02138,
        "lng": 76.59176,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.0219,
        "lng": 76.59313,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.02108,
        "lng": 76.59373,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "Ind",
        "caste": "SC"
      },
      {
        "lat": 31.02165,
        "lng": 76.59332,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.02163,
        "lng": 76.59322,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP WPD Ind",
        "caste": "Gen"
      },
      {
        "lat": 31.02191,
        "lng": 76.59309,
        "cand": "Undecided",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02165,
        "lng": 76.59287,
        "cand": "DJ",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02075,
        "lng": 76.59341,
        "cand": "JSA",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Saini"
      },
      {
        "lat": 31.02189,
        "lng": 76.59305,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "None",
        "caste": "Gen"
      },
      {
        "lat": 31.02194,
        "lng": 76.59311,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gujjar"
      },
      {
        "lat": 31.0216,
        "lng": 76.59299,
        "cand": "GSG",
        "cm": "Bhagwant Mann",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02179,
        "lng": 76.59194,
        "cand": "Undecided",
        "cm": "Charanjeet Channi",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "BJP",
        "caste": "Gen"
      },
      {
        "lat": 31.02201,
        "lng": 76.59187,
        "cand": "SSB",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "BC"
      },
      {
        "lat": 31.02086,
        "lng": 76.5935,
        "cand": "Undecided",
        "cm": "Amritpal Singh",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      },
      {
        "lat": 31.02185,
        "lng": 76.59324,
        "cand": "Undecided",
        "cm": "Undecided",
        "zone": "Central (Ghanauli / Ropar Rural)",
        "party": "WPD",
        "caste": "Gen"
      }
    ]
  }
}'::jsonb
)
ON CONFLICT (slug) DO UPDATE
SET 
    title = EXCLUDED.title,
    data = EXCLUDED.data,
    updated_at = timezone('utc'::text, now());

-- 4. Verify insertion
SELECT slug, title, (data->'meta'->>'sampleSize')::int as sample_size, updated_at FROM public.reports;
