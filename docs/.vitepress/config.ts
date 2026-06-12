import { defineConfig } from 'vitepress'

const REPO_URL = 'https://github.com/ADORSYS-GIS/ai-governance'

export default defineConfig({
  base: '/ai-governance/',
  title: 'AI-Helm Governance',
  description:
    'Copy-paste-ready Scrum artifacts for AI-heavy teams — a discipline layer of human accountability, verification, and intent preservation on top of AI-assisted work.',
  lastUpdated: true,
  cleanUrls: true,
  themeConfig: {
    search: { provider: 'local' },
    nav: [
      { text: 'Vocabulary', link: '/00-vocabulary' },
      { text: 'Doctrine', link: '/13-doctrine' },
      { text: 'Perspectives', link: '/perspectives/scrum-in-the-ai-era' },
      { text: 'Who uses this', link: '/adopters' },
      { text: 'GitHub', link: REPO_URL },
    ],
    sidebar: [
      {
        text: 'Foundations',
        items: [{ text: 'Vocabulary', link: '/00-vocabulary' }],
      },
      {
        text: 'Work items',
        items: [
          { text: 'Epic template', link: '/01-epic-template' },
          { text: 'User story template', link: '/02-user-story-template' },
          { text: 'Development ticket template', link: '/03-dev-ticket-template' },
          { text: 'Pull request template', link: '/04-pull-request-template' },
        ],
      },
      {
        text: 'Gates & checklists',
        items: [
          { text: 'AI ticket review checklist', link: '/05-ai-ticket-review-checklist' },
          { text: 'Definition of Ready', link: '/06-definition-of-ready' },
          { text: 'Definition of Done', link: '/07-definition-of-done' },
          { text: 'Refinement checklist', link: '/08-refinement-checklist' },
        ],
      },
      {
        text: 'Ceremonies',
        items: [
          { text: 'Daily scrum', link: '/09-daily-scrum' },
          { text: 'Sprint review', link: '/10-sprint-review' },
          { text: 'Sprint retrospective', link: '/11-sprint-retrospective' },
        ],
      },
      {
        text: 'Culture',
        items: [
          { text: 'AI working agreement', link: '/12-ai-working-agreement' },
          { text: 'Doctrine', link: '/13-doctrine' },
        ],
      },
      {
        text: 'Perspectives',
        items: [
          { text: 'Will Scrum survive the AI era?', link: '/perspectives/scrum-in-the-ai-era' },
          { text: 'The case that it survives', link: '/perspectives/the-case-it-survives' },
          { text: 'The case that it fades', link: '/perspectives/the-case-it-fades' },
        ],
      },
      {
        text: 'Adoption',
        items: [{ text: 'Who uses this', link: '/adopters' }],
      },
    ],
    socialLinks: [{ icon: 'github', link: REPO_URL }],
  },
})
