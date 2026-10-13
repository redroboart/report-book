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
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

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
    "subtitle": "A field report on candidate recall, popularity, and voter favorability in Roopnagar (Ropar), prepared for Waris Punjab De.",
    "client": "Waris Punjab De",
    "constituency": "Roopnagar (Ropar)",
    "fieldDates": "October 2026",
    "sampleSize": 599,
    "marginOfError": 4.0,
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
      "name": "Sukhwinder Singh Barra",
      "party": "Waris Punjab De / Akali",
      "isClient": true,
      "firstTime": true,
      "tagline": "Decisive leader in Akali voter favorability (65%) with strong rural and community goodwill.",
      "age": 42,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Social worker and agrarian organiser",
      "hometown": "Barwa, Roopnagar",
      "publicRole": "Local organiser & community advocate",
      "languages": "Punjabi, Hindi",
      "socialReach": "38K followers",
      "recall": 53,
      "favourable": 65,
      "unfavourable": 15,
      "intent": 22,
      "trend": [
        16,
        17,
        19,
        20,
        21,
        22
      ]
    },
    {
      "id": "GG",
      "name": "Gurinder Singh Gogi",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Second-ranked in Akali voter favorability (25%); moderate visibility across towns.",
      "age": 40,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Trader and local representative",
      "hometown": "Roopnagar Town",
      "publicRole": "Municipal & business organiser",
      "languages": "Punjabi, Hindi",
      "socialReach": "18K followers",
      "recall": 37,
      "favourable": 38,
      "unfavourable": 18,
      "intent": 9,
      "trend": [
        7,
        8,
        8,
        8,
        9,
        9
      ]
    },
    {
      "id": "DJ",
      "name": "Dalvir Jatana",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Third in Akali voter favorability (18%); focused rural presence.",
      "age": 38,
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Agriculturist",
      "hometown": "Jatana, Roopnagar",
      "publicRole": "Kisan union representative",
      "languages": "Punjabi, Hindi",
      "socialReach": "12K followers",
      "recall": 23,
      "favourable": 26,
      "unfavourable": 16,
      "intent": 6,
      "trend": [
        4,
        5,
        5,
        5,
        6,
        6
      ]
    },
    {
      "id": "JA",
      "name": "Jarnail Singh Aulakh",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "High elder recall (56% in 51+), but lowest voter favorability conversion (12%).",
      "age": 52,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Senior community worker",
      "hometown": "Aulakh, Roopnagar",
      "publicRole": "Panthic circle veteran",
      "languages": "Punjabi, Hindi",
      "socialReach": "15K followers",
      "recall": 41,
      "favourable": 28,
      "unfavourable": 22,
      "intent": 4,
      "trend": [
        5,
        5,
        4,
        4,
        4,
        4
      ]
    },
    {
      "id": "AL",
      "name": "Ajaiveer Lalpura",
      "party": "BJP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Highest overall name recall (73%) driven by prominent family background; strong in Hindu and BC belts.",
      "age": 35,
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Youth leader & entrepreneur",
      "hometown": "Anandpur Sahib / Ropar",
      "publicRole": "BJP youth face",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "85K followers",
      "recall": 73,
      "favourable": 42,
      "unfavourable": 32,
      "intent": 18,
      "trend": [
        15,
        16,
        17,
        17,
        18,
        18
      ]
    },
    {
      "id": "AS",
      "name": "Ashwani Sharma",
      "party": "Congress",
      "isClient": false,
      "firstTime": true,
      "tagline": "Strongest recall in urban Roopnagar and senior age brackets (55% in 51+).",
      "age": 44,
      "gender": "Male",
      "education": "Professional Degree",
      "profession": "Advocate",
      "hometown": "Roopnagar City",
      "publicRole": "Congress legal cell & party worker",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "24K followers",
      "recall": 45,
      "favourable": 36,
      "unfavourable": 24,
      "intent": 14,
      "trend": [
        12,
        13,
        13,
        14,
        14,
        14
      ]
    },
    {
      "id": "RM",
      "name": "Ramkumar Mukari",
      "party": "AAP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Beneficiary of ruling AAP vote base; strongest in Hindu (40%) and General demographics.",
      "age": 39,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Social organiser",
      "hometown": "Mukari, Roopnagar",
      "publicRole": "AAP constituency coordinator",
      "languages": "Punjabi, Hindi",
      "socialReach": "19K followers",
      "recall": 30,
      "favourable": 29,
      "unfavourable": 20,
      "intent": 11,
      "trend": [
        9,
        10,
        10,
        10,
        11,
        11
      ]
    }
  ],
  "segments": [
    {
      "group": "Age",
      "label": "18\u201325",
      "values": {
        "AL": 67,
        "SB": 50,
        "AS": 29,
        "JA": 16,
        "GG": 23,
        "RM": 17,
        "DJ": 18
      }
    },
    {
      "group": "Age",
      "label": "26\u201335",
      "values": {
        "AL": 75,
        "SB": 53,
        "AS": 41,
        "JA": 30,
        "GG": 31,
        "RM": 23,
        "DJ": 20
      }
    },
    {
      "group": "Age",
      "label": "36\u201350",
      "values": {
        "AL": 74,
        "SB": 57,
        "AS": 48,
        "JA": 48,
        "GG": 44,
        "RM": 34,
        "DJ": 28
      }
    },
    {
      "group": "Age",
      "label": "51 and above",
      "values": {
        "AL": 75,
        "SB": 50,
        "AS": 55,
        "JA": 56,
        "GG": 43,
        "RM": 38,
        "DJ": 24
      }
    },
    {
      "group": "Religion",
      "label": "Sikh",
      "values": {
        "AL": 65,
        "SB": 53,
        "AS": 34,
        "JA": 36,
        "GG": 33,
        "RM": 21,
        "DJ": 27
      }
    },
    {
      "group": "Religion",
      "label": "Hindu",
      "values": {
        "AL": 83,
        "SB": 53,
        "AS": 58,
        "JA": 46,
        "GG": 42,
        "RM": 40,
        "DJ": 19
      }
    },
    {
      "group": "Caste",
      "label": "Gen",
      "values": {
        "AL": 71,
        "SB": 57,
        "AS": 42,
        "JA": 35,
        "GG": 36,
        "RM": 30,
        "DJ": 24
      }
    },
    {
      "group": "Caste",
      "label": "SC",
      "values": {
        "AL": 72,
        "SB": 47,
        "AS": 41,
        "JA": 40,
        "GG": 31,
        "RM": 22,
        "DJ": 22
      }
    },
    {
      "group": "Caste",
      "label": "BC",
      "values": {
        "AL": 81,
        "SB": 43,
        "AS": 49,
        "JA": 54,
        "GG": 36,
        "RM": 32,
        "DJ": 26
      }
    },
    {
      "group": "Caste",
      "label": "OBC",
      "values": {
        "AL": 78,
        "SB": 50,
        "AS": 48,
        "JA": 38,
        "GG": 36,
        "RM": 30,
        "DJ": 14
      }
    },
    {
      "group": "Caste",
      "label": "Saini",
      "values": {
        "AL": 65,
        "SB": 63,
        "AS": 51,
        "JA": 45,
        "GG": 45,
        "RM": 39,
        "DJ": 27
      }
    },
    {
      "group": "Caste",
      "label": "Gujjar",
      "values": {
        "AL": 80,
        "SB": 57,
        "AS": 63,
        "JA": 46,
        "GG": 63,
        "RM": 40,
        "DJ": 23
      }
    }
  ],
  "analystNotes": [
    "Ajaiveer Lalpura (BJP) leads overall name recall at 73% across Roopnagar, with peak visibility among Hindu (83%) and BC (81%) voters.",
    "Among the four Akali-background aspirants, Sukhwinder Singh Barra commands an overwhelming lead: 53% recall and 64.9% voter favorability.",
    "Gurinder Singh Gogi holds second position in Akali voter favorability at 25.4%, trailing Barra by 39.5 points.",
    "Jarnail Singh Aulakh possesses solid elder name recall (56% in 51+), but records the lowest vote favorability conversion at 12.2%.",
    "Waris Punjab De (WPD) sentiment is prominent across Roopnagar with 50.8% voter favorability in party choices, establishing a strong receptive base."
  ],
  "voices": [
    {
      "id": "v1",
      "name": "Local Journalist 1",
      "type": "Reporter",
      "outlet": "Roopnagar Regional Daily",
      "date": "2026-10-09",
      "tone": "Positive",
      "mentions": [
        "SB",
        "AL"
      ],
      "bullets": [
        "Notes Sukhwinder Singh Barra enjoys high grassroots goodwill and accessibility in rural panchayats.",
        "Observes Ajaiveer Lalpura has significant media presence and urban name recognition, but faces resistance in rural agrarian belts."
      ]
    },
    {
      "id": "v2",
      "name": "Political Analyst",
      "type": "Opinion maker",
      "outlet": "Independent Panthic Review",
      "date": "2026-10-10",
      "tone": "Mixed",
      "mentions": [
        "SB",
        "GG",
        "JA",
        "DJ"
      ],
      "bullets": [
        "Warns against vote division: four Akali-background freshers contesting simultaneously will fragment the base.",
        "Emphasizes that uniting behind Sukhwinder Singh Barra creates an immediate contender against the BJP and Congress aspirants."
      ]
    },
    {
      "id": "v3",
      "name": "Youth Organiser",
      "type": "Opinion maker",
      "outlet": "Student Association, Roopnagar",
      "date": "2026-10-10",
      "tone": "Positive",
      "mentions": [
        "SB",
        "AL",
        "RM"
      ],
      "bullets": [
        "Points out 18\u201325 voters are leaning between WPD youth messaging and ruling AAP benefits.",
        "States that youth turnout will decide whether Barra can eclipse Lalpura''s early recall lead."
      ]
    },
    {
      "id": "v4",
      "name": "Constituency Reporter",
      "type": "Reporter",
      "outlet": "Doaba Tribune",
      "date": "2026-10-11",
      "tone": "Mixed",
      "mentions": [
        "AS",
        "RM"
      ],
      "bullets": [
        "Ashwani Sharma maintains traditional Congress urban pockets and elder recall (55%).",
        "Ramkumar Mukari''s prospects hinge entirely on government anti-incumbency vs AAP party apparatus."
      ]
    }
  ],
  "actions": [
    {
      "priority": "High",
      "title": "Consolidate Behind Sukhwinder Singh Barra",
      "detail": "Barra secures 64.9% favorability among Akali-leaning voters. Formalize ticket coordination to prevent Gogi (25%) and Jatana (18%) from splintering the core vote."
    },
    {
      "priority": "High",
      "title": "Close the Youth Recall Deficit (18\u201325)",
      "detail": "Ajaiveer Lalpura leads youth recall at 67% vs Barra''s 50%. Deploy an intensive digital and college campus outreach campaign across Roopnagar."
    },
    {
      "priority": "Medium",
      "title": "Counter Lalpura in Semi-Urban & BC Belts",
      "detail": "Lalpura commands 81% recall in BC and 83% in Hindu demographics. Craft localized economic and community-focused messaging to bridge this gap."
    },
    {
      "priority": "Medium",
      "title": "Mobilize the Pro-WPD Base",
      "detail": "With 50.8% of surveyed respondents naming WPD as their party preference, focus field resources on voter turnout and booth management."
    }
  ],
  "method": {
    "mode": "Direct field survey conducted via mobile tablets across Roopnagar assembly constituency.",
    "sampling": "Representative random sampling across urban, semi-urban, and rural polling wards (N=599 respondents).",
    "weighting": "Multi-select recall tested across seven fresh aspirants; dedicated vote favorability tested among the four Akali-background candidates.",
    "qualitative": "Field interviews and structured feedback from local reporters, youth coordinators, and opinion leaders.",
    "limits": [
      "Margin of error is \u00b14.0% at a 95% confidence level.",
      "Vote favorability was specifically evaluated among the four Akali-background freshers.",
      "Recall figures reflect unprompted & multi-select recognition as of fieldwork dates."
    ]
  }
}'::jsonb
)
ON CONFLICT (slug) DO UPDATE
SET data = EXCLUDED.data,
    title = EXCLUDED.title,
    updated_at = timezone('utc'::text, now());

-- Also update 'latest' record for compatibility
INSERT INTO public.reports (slug, title, data)
VALUES (
    'latest',
    'Roopnagar Popularity Check: Seven Aspirants',
    '{
  "meta": {
    "placeholder": false,
    "sameContest": true,
    "title": "Roopnagar Popularity Check: Seven Aspirants",
    "subtitle": "A field report on candidate recall, popularity, and voter favorability in Roopnagar (Ropar), prepared for Waris Punjab De.",
    "client": "Waris Punjab De",
    "constituency": "Roopnagar (Ropar)",
    "fieldDates": "October 2026",
    "sampleSize": 599,
    "marginOfError": 4.0,
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
      "name": "Sukhwinder Singh Barra",
      "party": "Waris Punjab De / Akali",
      "isClient": true,
      "firstTime": true,
      "tagline": "Decisive leader in Akali voter favorability (65%) with strong rural and community goodwill.",
      "age": 42,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Social worker and agrarian organiser",
      "hometown": "Barwa, Roopnagar",
      "publicRole": "Local organiser & community advocate",
      "languages": "Punjabi, Hindi",
      "socialReach": "38K followers",
      "recall": 53,
      "favourable": 65,
      "unfavourable": 15,
      "intent": 22,
      "trend": [
        16,
        17,
        19,
        20,
        21,
        22
      ]
    },
    {
      "id": "GG",
      "name": "Gurinder Singh Gogi",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Second-ranked in Akali voter favorability (25%); moderate visibility across towns.",
      "age": 40,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Trader and local representative",
      "hometown": "Roopnagar Town",
      "publicRole": "Municipal & business organiser",
      "languages": "Punjabi, Hindi",
      "socialReach": "18K followers",
      "recall": 37,
      "favourable": 38,
      "unfavourable": 18,
      "intent": 9,
      "trend": [
        7,
        8,
        8,
        8,
        9,
        9
      ]
    },
    {
      "id": "DJ",
      "name": "Dalvir Jatana",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "Third in Akali voter favorability (18%); focused rural presence.",
      "age": 38,
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Agriculturist",
      "hometown": "Jatana, Roopnagar",
      "publicRole": "Kisan union representative",
      "languages": "Punjabi, Hindi",
      "socialReach": "12K followers",
      "recall": 23,
      "favourable": 26,
      "unfavourable": 16,
      "intent": 6,
      "trend": [
        4,
        5,
        5,
        5,
        6,
        6
      ]
    },
    {
      "id": "JA",
      "name": "Jarnail Singh Aulakh",
      "party": "Akali Background",
      "isClient": true,
      "firstTime": true,
      "tagline": "High elder recall (56% in 51+), but lowest voter favorability conversion (12%).",
      "age": 52,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Senior community worker",
      "hometown": "Aulakh, Roopnagar",
      "publicRole": "Panthic circle veteran",
      "languages": "Punjabi, Hindi",
      "socialReach": "15K followers",
      "recall": 41,
      "favourable": 28,
      "unfavourable": 22,
      "intent": 4,
      "trend": [
        5,
        5,
        4,
        4,
        4,
        4
      ]
    },
    {
      "id": "AL",
      "name": "Ajaiveer Lalpura",
      "party": "BJP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Highest overall name recall (73%) driven by prominent family background; strong in Hindu and BC belts.",
      "age": 35,
      "gender": "Male",
      "education": "Post-graduate",
      "profession": "Youth leader & entrepreneur",
      "hometown": "Anandpur Sahib / Ropar",
      "publicRole": "BJP youth face",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "85K followers",
      "recall": 73,
      "favourable": 42,
      "unfavourable": 32,
      "intent": 18,
      "trend": [
        15,
        16,
        17,
        17,
        18,
        18
      ]
    },
    {
      "id": "AS",
      "name": "Ashwani Sharma",
      "party": "Congress",
      "isClient": false,
      "firstTime": true,
      "tagline": "Strongest recall in urban Roopnagar and senior age brackets (55% in 51+).",
      "age": 44,
      "gender": "Male",
      "education": "Professional Degree",
      "profession": "Advocate",
      "hometown": "Roopnagar City",
      "publicRole": "Congress legal cell & party worker",
      "languages": "Punjabi, Hindi, English",
      "socialReach": "24K followers",
      "recall": 45,
      "favourable": 36,
      "unfavourable": 24,
      "intent": 14,
      "trend": [
        12,
        13,
        13,
        14,
        14,
        14
      ]
    },
    {
      "id": "RM",
      "name": "Ramkumar Mukari",
      "party": "AAP",
      "isClient": false,
      "firstTime": true,
      "tagline": "Beneficiary of ruling AAP vote base; strongest in Hindu (40%) and General demographics.",
      "age": 39,
      "gender": "Male",
      "education": "Graduate",
      "profession": "Social organiser",
      "hometown": "Mukari, Roopnagar",
      "publicRole": "AAP constituency coordinator",
      "languages": "Punjabi, Hindi",
      "socialReach": "19K followers",
      "recall": 30,
      "favourable": 29,
      "unfavourable": 20,
      "intent": 11,
      "trend": [
        9,
        10,
        10,
        10,
        11,
        11
      ]
    }
  ],
  "segments": [
    {
      "group": "Age",
      "label": "18\u201325",
      "values": {
        "AL": 67,
        "SB": 50,
        "AS": 29,
        "JA": 16,
        "GG": 23,
        "RM": 17,
        "DJ": 18
      }
    },
    {
      "group": "Age",
      "label": "26\u201335",
      "values": {
        "AL": 75,
        "SB": 53,
        "AS": 41,
        "JA": 30,
        "GG": 31,
        "RM": 23,
        "DJ": 20
      }
    },
    {
      "group": "Age",
      "label": "36\u201350",
      "values": {
        "AL": 74,
        "SB": 57,
        "AS": 48,
        "JA": 48,
        "GG": 44,
        "RM": 34,
        "DJ": 28
      }
    },
    {
      "group": "Age",
      "label": "51 and above",
      "values": {
        "AL": 75,
        "SB": 50,
        "AS": 55,
        "JA": 56,
        "GG": 43,
        "RM": 38,
        "DJ": 24
      }
    },
    {
      "group": "Religion",
      "label": "Sikh",
      "values": {
        "AL": 65,
        "SB": 53,
        "AS": 34,
        "JA": 36,
        "GG": 33,
        "RM": 21,
        "DJ": 27
      }
    },
    {
      "group": "Religion",
      "label": "Hindu",
      "values": {
        "AL": 83,
        "SB": 53,
        "AS": 58,
        "JA": 46,
        "GG": 42,
        "RM": 40,
        "DJ": 19
      }
    },
    {
      "group": "Caste",
      "label": "Gen",
      "values": {
        "AL": 71,
        "SB": 57,
        "AS": 42,
        "JA": 35,
        "GG": 36,
        "RM": 30,
        "DJ": 24
      }
    },
    {
      "group": "Caste",
      "label": "SC",
      "values": {
        "AL": 72,
        "SB": 47,
        "AS": 41,
        "JA": 40,
        "GG": 31,
        "RM": 22,
        "DJ": 22
      }
    },
    {
      "group": "Caste",
      "label": "BC",
      "values": {
        "AL": 81,
        "SB": 43,
        "AS": 49,
        "JA": 54,
        "GG": 36,
        "RM": 32,
        "DJ": 26
      }
    },
    {
      "group": "Caste",
      "label": "OBC",
      "values": {
        "AL": 78,
        "SB": 50,
        "AS": 48,
        "JA": 38,
        "GG": 36,
        "RM": 30,
        "DJ": 14
      }
    },
    {
      "group": "Caste",
      "label": "Saini",
      "values": {
        "AL": 65,
        "SB": 63,
        "AS": 51,
        "JA": 45,
        "GG": 45,
        "RM": 39,
        "DJ": 27
      }
    },
    {
      "group": "Caste",
      "label": "Gujjar",
      "values": {
        "AL": 80,
        "SB": 57,
        "AS": 63,
        "JA": 46,
        "GG": 63,
        "RM": 40,
        "DJ": 23
      }
    }
  ],
  "analystNotes": [
    "Ajaiveer Lalpura (BJP) leads overall name recall at 73% across Roopnagar, with peak visibility among Hindu (83%) and BC (81%) voters.",
    "Among the four Akali-background aspirants, Sukhwinder Singh Barra commands an overwhelming lead: 53% recall and 64.9% voter favorability.",
    "Gurinder Singh Gogi holds second position in Akali voter favorability at 25.4%, trailing Barra by 39.5 points.",
    "Jarnail Singh Aulakh possesses solid elder name recall (56% in 51+), but records the lowest vote favorability conversion at 12.2%.",
    "Waris Punjab De (WPD) sentiment is prominent across Roopnagar with 50.8% voter favorability in party choices, establishing a strong receptive base."
  ],
  "voices": [
    {
      "id": "v1",
      "name": "Local Journalist 1",
      "type": "Reporter",
      "outlet": "Roopnagar Regional Daily",
      "date": "2026-10-09",
      "tone": "Positive",
      "mentions": [
        "SB",
        "AL"
      ],
      "bullets": [
        "Notes Sukhwinder Singh Barra enjoys high grassroots goodwill and accessibility in rural panchayats.",
        "Observes Ajaiveer Lalpura has significant media presence and urban name recognition, but faces resistance in rural agrarian belts."
      ]
    },
    {
      "id": "v2",
      "name": "Political Analyst",
      "type": "Opinion maker",
      "outlet": "Independent Panthic Review",
      "date": "2026-10-10",
      "tone": "Mixed",
      "mentions": [
        "SB",
        "GG",
        "JA",
        "DJ"
      ],
      "bullets": [
        "Warns against vote division: four Akali-background freshers contesting simultaneously will fragment the base.",
        "Emphasizes that uniting behind Sukhwinder Singh Barra creates an immediate contender against the BJP and Congress aspirants."
      ]
    },
    {
      "id": "v3",
      "name": "Youth Organiser",
      "type": "Opinion maker",
      "outlet": "Student Association, Roopnagar",
      "date": "2026-10-10",
      "tone": "Positive",
      "mentions": [
        "SB",
        "AL",
        "RM"
      ],
      "bullets": [
        "Points out 18\u201325 voters are leaning between WPD youth messaging and ruling AAP benefits.",
        "States that youth turnout will decide whether Barra can eclipse Lalpura''s early recall lead."
      ]
    },
    {
      "id": "v4",
      "name": "Constituency Reporter",
      "type": "Reporter",
      "outlet": "Doaba Tribune",
      "date": "2026-10-11",
      "tone": "Mixed",
      "mentions": [
        "AS",
        "RM"
      ],
      "bullets": [
        "Ashwani Sharma maintains traditional Congress urban pockets and elder recall (55%).",
        "Ramkumar Mukari''s prospects hinge entirely on government anti-incumbency vs AAP party apparatus."
      ]
    }
  ],
  "actions": [
    {
      "priority": "High",
      "title": "Consolidate Behind Sukhwinder Singh Barra",
      "detail": "Barra secures 64.9% favorability among Akali-leaning voters. Formalize ticket coordination to prevent Gogi (25%) and Jatana (18%) from splintering the core vote."
    },
    {
      "priority": "High",
      "title": "Close the Youth Recall Deficit (18\u201325)",
      "detail": "Ajaiveer Lalpura leads youth recall at 67% vs Barra''s 50%. Deploy an intensive digital and college campus outreach campaign across Roopnagar."
    },
    {
      "priority": "Medium",
      "title": "Counter Lalpura in Semi-Urban & BC Belts",
      "detail": "Lalpura commands 81% recall in BC and 83% in Hindu demographics. Craft localized economic and community-focused messaging to bridge this gap."
    },
    {
      "priority": "Medium",
      "title": "Mobilize the Pro-WPD Base",
      "detail": "With 50.8% of surveyed respondents naming WPD as their party preference, focus field resources on voter turnout and booth management."
    }
  ],
  "method": {
    "mode": "Direct field survey conducted via mobile tablets across Roopnagar assembly constituency.",
    "sampling": "Representative random sampling across urban, semi-urban, and rural polling wards (N=599 respondents).",
    "weighting": "Multi-select recall tested across seven fresh aspirants; dedicated vote favorability tested among the four Akali-background candidates.",
    "qualitative": "Field interviews and structured feedback from local reporters, youth coordinators, and opinion leaders.",
    "limits": [
      "Margin of error is \u00b14.0% at a 95% confidence level.",
      "Vote favorability was specifically evaluated among the four Akali-background freshers.",
      "Recall figures reflect unprompted & multi-select recognition as of fieldwork dates."
    ]
  }
}'::jsonb
)
ON CONFLICT (slug) DO UPDATE
SET data = EXCLUDED.data,
    title = EXCLUDED.title,
    updated_at = timezone('utc'::text, now());
