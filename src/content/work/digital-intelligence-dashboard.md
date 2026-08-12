---
title: Digital Intelligence Dashboard
year: '2026'
category: Audience Intelligence & Digital Product
companyOrClient: GMA New Media Inc.
anonymized: false
shortDescription: A working internal pilot that consolidates five separate intelligence platforms — GA4, Similarweb, Semrush, Chartbeat, and Google Trends — into one source-labeled decision interface.
overview: GMA's digital teams work across several capable intelligence platforms — each answering a different question, on a different reporting period, by a different method. The dashboard is a decision layer across those sources rather than an attempt to merge unlike data into one authoritative view. First-party data establishes what happened; external intelligence helps explain the environment around it.
role: Product concept, information architecture, data-source strategy, AI-assisted development, QA, and operational design and documentation. I built the working application through an AI-assisted development workflow with Claude Code, connected the company's existing analytics and intelligence APIs, and deployed it on Cloudflare.
context:
  - "GMA's digital teams already had access to several capable intelligence platforms: GA4 for first-party owned performance, Similarweb for directional market and competitive estimates, Semrush for search intelligence, Chartbeat for real-time activity, and Google Trends for current topic and search-interest context."
  - Each platform answered a different question, on its own reporting period and methodology. The constraint was not a lack of data but fragmentation.
  - To understand audience performance, competitive context, search visibility, and current attention together, decision-makers had to move between several tools.
approach:
  - Framed the product as a decision layer across existing platforms, with first-party data describing owned performance and external sources providing market, competitive, search, and real-time context.
  - Anchored owned audience, sessions, views, engagement, and content performance in GA4.
  - Built a Performance Overview that combines source-labeled intelligence without treating unlike metrics as equivalents, and generates up to three rule-based observations, each carrying its source and reporting period.
  - Added a configurable content taxonomy that can represent different sites, sections, programs, formats, or campaign hierarchies.
  - Paired Google Trends search-interest signals with Chartbeat real-time page activity to read current attention.
  - Included source-health monitoring, visible reporting periods and cache state, and browser-based routine operational controls.
  - Used source-specific caching and safeguards — lazy-loaded paid modules and administrator-only force-refresh — to protect finite Similarweb and Semrush usage.
outcome: "The result is a working pilot that brings five distinct intelligence sources into a source-labeled decision interface, with browser-based operations and safeguards for finite API usage. It has been shared internally with Business Development and Analytics for initial evaluation — a pilot rather than an established production workflow. The idea itself is not new: it traces back roughly seven years, to an unfinished concept for a digital command center. The working name, DESQ, stood for Digital Engagement and Storytelling and a Q we never settled — Quay, Quad, Quarter — and stuck mainly because it sounded like a news desk. What changed was feasibility, as AI-assisted development made it possible to turn a long-standing idea into a working product."
tools:
  - GA4
  - Similarweb
  - Semrush
  - Chartbeat
  - Google Trends
  - Cloudflare
  - Claude Code
tags:
  - Audience Intelligence
  - Analytics
  - Internal Product
confidentialityNote: Internal screens, data, account details, vendor usage details, and proprietary configuration are withheld; sanitized visuals will be added separately.
featured: false
order: 1.5
draft: false
---
