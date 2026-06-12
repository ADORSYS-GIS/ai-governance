# Will Scrum survive the AI era?

A perspective on the question every AI-heavy team eventually asks — and the framing
this kit is built on. It is written as a debate: the [case that it survives](/perspectives/the-case-it-survives)
and the [case that it fades](/perspectives/the-case-it-fades) each get their own page.
This page sets up the question and states where we land.

## First, split "Scrum" into two things

Most arguments about this go nowhere because they conflate two very different things:

- **The kernel** — *empirical process control*: transparency → inspection → adaptation
  under uncertainty, short feedback loops, working software over documents, responding
  to change. This is the Agile Manifesto's actual claim.
- **The ceremony** — two-week sprints, story points, planning poker, velocity and
  burndown, the standup-as-status, the rigid PO / SM / dev-team split, the scaled
  scaffolding sold to executives.

These have different fates. Argue about them together and you get a mushy answer.
Separate them and the picture sharpens.

## What AI actually changes

One structural shift drives everything else:

> **AI collapses the cost of producing code, so the bottleneck moves from "writing it"
> to "deciding what's right and verifying it."**

Four consequences follow:

1. **Feedback loops get radically shorter.** A feature that was two weeks is now an
   afternoon. That *amplifies* the Agile kernel — fast feedback is the whole point —
   while making a fixed two-week sprint look like an arbitrarily slow heartbeat.
2. **The constraint moves to review and verification capacity**, not dev capacity. You
   can generate ten implementations before lunch; you can't *trust* ten before lunch.
3. **Estimation breaks.** Story points proxied human effort. AI throughput is bursty and
   uncorrelated with complexity-as-humans-feel-it. Velocity starts measuring the wrong organ.
4. **Team size shrinks.** One human plus agents does what a six-person squad did — and
   much of Scrum's machinery exists to coordinate humans who can't see each other's work.

## The two cases

- **[The case that it survives →](/perspectives/the-case-it-survives)** — AI raises
  uncertainty about correctness and intent, which is exactly the condition empirical
  process control was built for. The kernel doesn't just survive; AI is the strongest
  argument for it ever made.
- **[The case that it fades →](/perspectives/the-case-it-fades)** — the ceremony was
  calibrated to a slower world. Estimation, velocity, the daily status sync, and the
  rigid sprint outlive their usefulness and decay into ritual.

## Where we land

Both cases are right about different halves of the same thing:

- **The Agile kernel doesn't just survive — it strengthens.** Faster feedback and higher
  uncertainty about correctness are the conditions it was designed for.
- **Scrum-the-ceremony, as practiced in 2015, mostly dies** — replaced by lighter,
  verification-centric loops. The standup becomes a review gate. Velocity becomes
  defect and intent-drift rates. The sprint becomes a verification cadence, not a
  delivery one.

Notice *what* survives: intent, a named source of truth, Definition of Ready and Done,
verification, human accountability. That is not a coincidence — it is precisely the
discipline this kit codifies. When generation is free and trust is scarce, the act of
saying *"this is correct and is what we meant"* **is** the work. See [the doctrine](/13-doctrine).

Two caveats keep the story honest:

- **Zombie Scrum will outlive useful Scrum.** Enterprises keep it for auditability,
  contractor management, and predictability for finance — forces that have nothing to do
  with efficiency. Survival is not vitality.
- **Scrum was always weak where AI now presses hardest: discovery.** It assumes a groomed
  backlog already exists. When building is trivial, *what is worth building* dominates —
  and discovery-centric ways of working may eat Scrum's lunch faster than Scrum can adapt.

> The interesting question is not whether Scrum survives. It is whether anyone keeps
> calling the surviving part "Scrum" — and whether they keep doing the part that
> actually mattered once the typing got cheap.
