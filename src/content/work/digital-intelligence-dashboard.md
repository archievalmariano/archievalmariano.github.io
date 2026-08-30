---
title: Turning a seven-year-old digital command center idea into a working intelligence dashboard
year: '2026'
category: Audience Intelligence & Digital Product
companyOrClient: GMA New Media Inc.
anonymized: false
shortDescription: At GMA New Media Inc., I turned a digital command center idea first discussed in 2019 into a working, source-labeled intelligence dashboard through an AI-assisted development workflow.
overview: At GMA New Media Inc., I built a working internal pilot that brings intelligence from GA4, Similarweb, Semrush, Chartbeat, and Google Trends into one source-labeled interface. It is designed to help editorial and digital teams find relevant signals without opening every platform separately or negotiating with more data than they need.
role: The original command center concept was collaborative. The current dashboard pilot was an independent project. I made the product, information architecture, source strategy, interface, and operational decisions. I determined which metrics were most relevant, how the different platforms should be presented, and where unlike measurements needed to remain clearly separated. I also built and tested the application through an AI-assisted development workflow with Claude Code and Codex. Management became aware of the project when I needed access to the API credentials required to connect the available platforms.
context:
  - The idea was first discussed in late 2019 and early 2020 with colleagues from GMA New Media's audience development and analytics teams. At the time, I was part of digital advertising, although I was already working on projects beyond my formal role.
  - We imagined a digital "war room" with monitors displaying useful information about GMA News Online and GMA Entertainment. It would show trend lines, current audience activity, and other signals that teams could act on. Google Analytics could tell us what was happening across GMA's owned properties, but it could not provide all the market, competitive, search, and real-time context we wanted.
  - We explored possible partners that could supply the missing information, but the additional platforms came with additional costs. Then the pandemic happened. With other priorities taking precedence and the organization understandably reluctant to add another paid platform, the command center remained an unfinished concept.
  - By 2026, Similarweb, Semrush, and Chartbeat were already available internally alongside GA4. AI-assisted development also made it possible to test the idea without first requesting a substantial allocation of development time.
approach:
  - Framed the dashboard as a decision layer across existing platforms rather than an attempt to merge unlike data into one authoritative number. GA4 establishes what happened across GMA's owned properties, while the other sources provide different forms of context.
  - Selected the signals most relevant to editorial decision-making and organized them so users could begin with a focused view instead of working through every platform's full interface.
  - Built source-labeled observations that retain their reporting periods and methodologies, along with source-health monitoring and visible cache states.
  - Used source-specific caching, lazy-loaded paid modules, and restricted forced refreshes to protect finite Similarweb and Semrush API allocations.
  - Added browser-based operational controls and a configurable content taxonomy for sites, sections, programs, formats, and campaigns.
outcome:
  - The initial response was supportive. Colleagues were pleasantly surprised to see someone outside the development team attempt a project of this scale.
  - Editorial teams were especially interested in having easier access to information from the organization's paid platforms. Instead of opening each service independently and working through its full interface, they could begin with a smaller set of signals selected for editorial decision-making.
  - The result is a working internal pilot rather than an established production system. It demonstrates that the long-standing command center idea can now be tested as a real product before the organization commits substantial development resources to it.
limitations:
  - Some Similarweb and Semrush capabilities that would be useful are not included in the organization's current plans or are unavailable through their APIs.
  - Both services impose monthly API-credit limits, and unused credits do not carry over. Because every refresh consumes part of that allocation, the dashboard is designed to call paid sources economically. GMA's Similarweb account manager reviewed the refresh pattern and confirmed that its usage was economical.
  - The available Google Trends data is daily rather than truly real-time. To supplement it, I added a way to upload CSV files downloaded from Google Trends manually.
  - These constraints are visible by design. The dashboard identifies its sources and reporting periods rather than presenting every number as directly comparable or equally current.
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
confidentialityNote: Internal screens, data, account details, vendor usage details, and proprietary configuration are withheld. Sanitized visuals will be added separately.
featured: true
order: 1.5
draft: false
---
