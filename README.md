# drmhbot [![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-success?logo=gitpod)](https://gitpod.io/#https://github.com/heyajulia/drmhbot) [![CircleCI](https://circleci.com/gh/heyajulia/drmhbot/tree/main.svg?style=shield&circle-token=8b73167479e8b3d0acd34821add79364f7f1727b)](https://circleci.com/gh/heyajulia/drmhbot/tree/main)

This is the source code for that powers [@DrudgeReportHeadlinesBot][bot]. It
posts the "main" [Drudge Report][drudge] headlines to the
[@DrudgeReportHeadlines][channel] Telegram channel.

The bot is currently running "serverlessly" on Heroku. [Heroku
Scheduler][scheduler] runs `hy src/main.hy` every 10 minutes. Persistence is
handled using [Heroku Redis][redis].

I hope to transition the bot to a "true" serverless environment one day. Until
then, this seems to work well enough. And it doesn't cost me anything.

[bot]: https://t.me/DrudgeReportHeadlinesBot
[drudge]: https://drudgereport.com
[channel]: https://t.me/s/DrudgeReportHeadlines
[scheduler]: https://elements.heroku.com/addons/scheduler
[redis]: https://elements.heroku.com/addons/heroku-redis
