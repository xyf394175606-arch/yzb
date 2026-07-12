---
name: axure-prototype-design
description: "Use when Codex needs to create or specify Axure-style business prototypes in Chinese: convert requirement-analysis prototype input into PC/mobile wireframes, page-level business annotations, right-side yellow requirement tags, page transitions, popups, states, and version/entry pages. Trigger on requests for Axure 原型设计, 原型设计, HTML 原型, 线框图, 黄色说明区, 页面跳转原型, PC/移动端原型, or turning 需求分析 into a prototype."
---

# Axure 原型设计

## Compatibility Role

Use this skill when structured requirement analysis or **原型设计输入** already exists and the user asks for Axure 原型设计, HTML 原型, 线框图, 页面跳转原型, or PC/移动端原型.

If the input is rough requirements, screenshots, old-system notes, old Axure reuse, or prototype review feedback, route to `requirements-to-axure-html-prototype`. That is the merged end-to-end coordinator.

Read these references before producing a full prototype specification or HTML prototype:

- `references/Axure原型设计_输出规范_v1_20260621.md`
- `/Users/xuyunfeng/.codex/skills/requirements-to-axure-html-prototype/references/需求原型合并规范_v1_20260702.md`

## Input Contract

Prefer input from `requirement-analysis`, especially **原型设计输入**. Confirm these items exist or mark them pending:

- Prototype scope: PC, mobile, or both.
- Page hierarchy tree and navigation ownership.
- Page list with side, purpose, and source rule.
- Page content notes: visible areas, fields, buttons, default state, empty/exception/no-permission states.
- Field notes: source, display/edit rule, and annotation need.
- Button notes: operation object, click result, jump/popup/save/refresh/state-change behavior.
- Business popup notes: owning page, selected-row fields, confirm result, cancel result, and pending points.
- PC/mobile differences and pending questions.

## Output Contract

Build a business-readable Axure-style deliverable:

- Real PC/mobile wireframes or clickable single-file HTML.
- Entry/navigation page when multiple pages exist.
- Page hierarchy based on requirement analysis, not only page names.
- Right-side yellow notes for business rules, field sources, button results, permissions, states, pending items, and reviewer explanations.
- Discoverable business popups under their owning page or module when they have independent fields, rules, status changes, or approval/enable/disable/confirmation meaning.

## Guardrails

- Do not create a pure UI mockup. Business rules must remain reviewable.
- The wireframe area contains only real user-visible UI.
- Do not place red reviewer explanations inside the phone/PC wireframe; convert them to yellow notes.
- Do not create empty pages from page names alone.
- Do not create empty clicks or generic browser alerts as business actions.
- Every clickable button must have a result or a visible pending marker.
- Do not put page states in the left navigation. Put state explanations under the related page notes.
- Preserve PC/mobile differences instead of assuming both sides are identical.
