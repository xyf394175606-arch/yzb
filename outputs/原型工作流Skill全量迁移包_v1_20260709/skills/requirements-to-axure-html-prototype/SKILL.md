---
name: requirements-to-axure-html-prototype
description: "Use when Codex needs to turn Chinese product requirements, rough business ideas, old-system notes, screenshots, Axure-style prototype references, or prototype review feedback into requirement analysis plus clickable Axure-style HTML prototypes. Trigger on Axure 原型调整, axure 原型调整, 需求到原型, 需求分析到原型设计, Axure风格HTML原型, 黄色说明区, 右侧需求说明, 旧Axure原型复用, PC/移动端业务原型, 原型反馈, 原型评审修改, 反哺需求文档, or feedback that may affect rules, pages, fields, states, popups, transitions, button results, and reviewer annotations."
---

# 需求到 Axure 风格 HTML 原型

## Overview

Use this skill as the end-to-end coordinator from product input to Axure-style HTML prototype. It keeps `requirement-analysis` and `axure-prototype-design` as specialized steps, then adds old-Axure pattern reuse, prototype feedback loops, and HTML prototype quality checks.

The deliverable is a business-readable prototype: real PC/mobile wireframes, clickable transitions, states/popups, and a right-side yellow requirement area for rules and reviewer notes.

## Required References

Read `references/需求原型合并规范_v1_20260702.md` first. It is the shared compatibility contract for `requirement-analysis`, `axure-prototype-design`, and this end-to-end skill.

Read `references/原型设计_旧Axure规律_v1_20260622.md` before designing or generating a full prototype.

Read `references/原型反馈_需求原型闭环_v1_20260623.md` when the user points out a prototype problem, asks for review changes, or gives feedback that may need to update both requirement analysis and prototype output.

Compatibility entries remain available when their trigger conditions apply:

- `requirement-analysis`: when input is rough, incomplete, screenshot-based, or needs business rules/fields/buttons/page transitions organized first.
- `axure-prototype-design`: when converting the requirement-analysis prototype input into page wireframes, yellow notes, popups, states, and transitions.

## Workflow

1. Judge input completeness.
   - If the user gives only an idea, first produce or request the minimum missing product facts: business scenario, user roles, PC/mobile scope, key pages, important actions, and available screenshots or old flows.
   - If the user gives notes, screenshots, old-system issues, or old Axure HTML, extract visible pages, fields, buttons, states, transitions, permissions, data ranges, and unclear points.
   - If existing requirement analysis is present, use its **原型设计输入** section directly.
2. Produce requirement analysis before drawing unless the user already supplied one.
   - Business rules come before fields.
   - Fields, buttons, page content, page transitions, PC/mobile differences, and pending questions must be explicit.
   - Preserve uncertain assumptions as **待确认问题**.
3. Build the prototype information architecture.
   - Define page hierarchy before page UI.
   - Separate PC and mobile scopes.
   - Do not put states in the navigation tree; states belong to their related page notes.
4. Select page patterns from the old Axure reference.
   - PC backend pages usually use left navigation, top bar, filter area, table/list, row actions, detail panels, approval flows, or report tables.
   - Mobile pages usually use a phone frame, app title area, list/detail/form/confirmation views, and explicit empty/error/loading states.
5. Generate the HTML prototype.
   - The wireframe area contains only user-visible UI.
   - Right-side yellow notes contain rules, field sources, button results, permissions, data range, status logic, version changes, pending questions, and reviewer-only explanations.
   - Buttons must either jump, open a business popup, save, refresh, return, change state, disable/hide, or be marked as pending.
6. Verify the prototype before final delivery.
   - Every page in the page list appears in the prototype.
   - Every page has visible content.
   - Every important field and button has a note or source.
   - No business-only rule is rendered as fake user UI.
   - Every click target, popup, state, and pending item is explicit.

## Prototype Feedback Loop

Use this loop when the user says a prototype page, field, button, rule, popup, state, wording, layout, or interaction is wrong or needs adjustment.

1. Locate the feedback target.
   - Identify the page, element, current behavior/content, expected change, and whether the feedback came from text, screenshot, or HTML.
   - If the target cannot be identified, ask only for the missing page/element location.
2. Classify the feedback before changing anything.
   - Business rule, field, button/action, page structure, transition, popup, state, permission, yellow note, visible text, or pure visual layout.
   - If classification is uncertain, treat it as potentially affecting requirements and mark the uncertainty.
3. Decide the feedback sink.
   - Rule/field/button/state/permission/transition changes must update requirement analysis sections and the prototype-design input.
   - Page layout, popup content, yellow notes, and clickable behavior must update the prototype plan or HTML.
   - Pure visual spacing/color/wording changes can update only the prototype, with a change record saying requirements are unaffected.
4. Preserve traceability.
   - Produce a change record with: feedback, classification, requirement impact, prototype impact, files/pages affected, result, and pending questions.
   - Do not silently change only the HTML when the feedback changes business meaning.
5. Re-verify affected pages.
   - Check related fields, buttons, states, jumps, popups, yellow notes, and PC/mobile differences after the change.

## HTML Prototype Requirements

- Prefer a single self-contained HTML file when the user asks for an HTML prototype.
- Include an entry/navigation page when multiple pages exist.
- Make page transitions clickable with anchors, buttons, or scripted navigation.
- Keep prototype annotations visually outside the PC/mobile wireframe. Use yellow note panels on the right for reviewer-facing content.
- Use Chinese business language. Do not describe APIs, databases, component frameworks, or backend implementation unless the user explicitly asks.
- For row actions, show the selected row's key fields in the target page or popup.
- For approval/reject/payment/confirm actions, show before status, after status, required reason/notes, confirm result, cancel result, and what the list/detail shows after completion.
- Business popups with independent business rules, fields, button results, status changes, or approval/enable/disable/confirmation meaning must appear as left-navigation nodes under their owning page or module. Clicking the popup navigation node should first enter the owning page, then open the corresponding popup.
- When exposing business popups in the left navigation, show ownership explicitly instead of flattening them as sibling pages. Prefer a tree, indentation, grouped children, breadcrumb label, or parent-row highlight so reviewers can see which list/detail/config page opens each popup.
- For pending or inferred content, mark it visibly as `待确认` instead of silently deciding it.
- For feedback iterations, keep a visible change record unless the user explicitly asks for a clean final-only output.

## Hard Rules

- Do not skip requirement analysis when the input lacks page content, button results, field sources, or transition logic.
- Do not create empty pages from page names alone.
- Do not create empty clicks or generic browser alerts as business actions.
- Do not put red explanatory text inside the real wireframe. Convert reviewer explanations into yellow notes.
- Do not turn internal rules, calculations, backend configuration, or pending questions into user-facing UI unless confirmed as visible content.
- Do not flatten page hierarchy when pages belong to different systems, entries, modules, child pages, details, or popups.
- Do not hide reviewable business popups only behind button clicks. They must be discoverable in the left navigation under the page or module that triggers them, unless they are simple notices/light confirmations with no independent fields or status result.
- Do not drop PC/mobile differences. If scope is unknown, mark it as pending.
- Do not treat prototype review feedback as a page-only edit until it has been classified. Feedback about popup discoverability or left-navigation placement is usually a page-structure/prototype adjustment; if it does not change business meaning, record the feedback but do not update requirement analysis.

## Validation Checklist

Before finalizing, check:

- Is there a requirement-analysis handoff or equivalent structured input?
- Are PC/mobile scope and page hierarchy clear?
- Does every page have visible user content and right-side notes?
- Are fields and buttons separate?
- Does every field have a source or pending marker?
- Does every button have a result?
- Are row actions tied to the selected row?
- Are popups real business popups with confirm/cancel results?
- Are reviewable business popups exposed in the left navigation under their owning page, and does the navigation open the owning page before the popup?
- Does the left navigation visually communicate popup ownership, such as by nesting popups under the triggering page or highlighting the parent when a child popup node is active?
- Are states documented under the related page rather than navigation?
- Are business rules and pending items kept out of the real UI?
- Is the HTML prototype clickable enough for review?
- For feedback iterations, does the change record identify what changed in requirements, prototype pages, and pending questions?
