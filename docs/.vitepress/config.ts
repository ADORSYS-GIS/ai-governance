import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'

const REPO_URL = 'https://github.com/ADORSYS-GIS/ai-governance'

export default withMermaid(defineConfig({
  vite: {
    ssr: {
      noExternal: ['mermaid', 'vitepress-plugin-mermaid'],
    },
  },
  base: '/ai-governance/',
  title: 'AI Delivery Governance',
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
         text: 'Integrations',
         items: [
           {
             text: 'OpenCode',
             collapsed: false,
             items: [
               { text: 'Overview', link: '/integrations/opencode/00-overview' },
               { text: 'VSCode', link: '/integrations/opencode/01-vscode' },
               { text: 'IntelliJ', link: '/integrations/opencode/02-intellij' },
               { text: 'CLI', link: '/integrations/opencode/03-cli' },
               { text: 'GitHub PR Reviews', link: '/integrations/opencode/04-github-pr-reviews' },
             ],
           },
           {
             text: 'GitHub Actions',
             collapsed: false,
             items: [
               { text: 'Overview', link: '/integrations/github-actions/00-github-actions' },
             ],
           },
           {
             text: 'Lightbridge Code Intelligence',
             collapsed: false,
             items: [
               { text: 'Overview', link: '/integrations/lightbridge-code-intelligence/00-overview' },
               { text: 'GitHub', link: '/integrations/lightbridge-code-intelligence/01-github-integration' },
               { text: 'GitLab', link: '/integrations/lightbridge-code-intelligence/02-gitlab-integration' },
             ],
           },
         ],
       },
      {
        text: 'Adoption',
        items: [{ text: 'Who uses this', link: '/adopters' }],
      },
    ],
    socialLinks: [{ icon: 'github', link: REPO_URL }],
  },
}))
