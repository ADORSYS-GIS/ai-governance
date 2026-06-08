# 5. AI-generated ticket review checklist

Use this when a ticket was written or heavily rewritten by AI.

---

# AI Ticket Review Checklist

## Intent

- [ ] Can a human explain the real intent without reading the AI text?
- [ ] Is the problem clearly stated?
- [ ] Is the expected outcome clear?
- [ ] Is this ticket solving a real need, not just creating activity?

## Source of Truth

- [ ] Is there a link to the original request, decision, incident, design, or metric?
- [ ] Are all important claims traceable to a source?
- [ ] Are there claims that sound plausible but are unsupported?

## Scope

- [ ] Is the scope explicit?
- [ ] Is out-of-scope explicit?
- [ ] Could a developer accidentally implement the wrong thing?
- [ ] Could this ticket cause unnecessary refactoring?

## Acceptance Criteria

- [ ] Are the acceptance criteria testable?
- [ ] Are edge cases included?
- [ ] Are failure cases included?
- [ ] Are security or permission cases included, if relevant?
- [ ] Are non-functional requirements included, if relevant?

## Technical Quality

- [ ] Are implementation notes separated from requirements?
- [ ] Are technical suggestions validated by a human?
- [ ] Are dependencies listed?
- [ ] Are risks listed?
- [ ] Are assumptions visible?

## Final Decision

- [ ] Ready for refinement
- [ ] Needs human clarification
- [ ] Needs Product Owner review
- [ ] Needs Technical Lead review
- [ ] Reject and rewrite
