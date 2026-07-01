---
name: create-plan
description: Create a claude code plan with custom filename formatting. Use when planning to ensure filenames are easily searchable by users and claude in the future. YOU MUST USE THIS WHEN PLANNING PLAN WRITING PLAN
allowed-tools: Read, Grep, Glob, Base
---

# Create Named Plan

When creating a plan, use this naming convention:

**Format**: `$project-plan-DDMMYY-HH_MM`

Where:
- `$project`: The project name (from $ARGUMENTS or inferred from current directory/context)
- `DDMMYY`: Current date (day-month-year)
- `HH_MM`: Current time (24hr format with underscore separator)

## Instructions

1. Determine the project name:
   - Use explicitly provided name from arguments
   - Or infer from current working directory name
   - Or ask the user

2. Generate the filename:
   ```bash
   date "+%d%m%y-%H_%M"
   ```

3. Create the plan file at: `~/.claude/plans/$project-plan-DDMMYY-HH_MM.md`

4. The plan content should follow standard planning structure:
   - **Objective**: What we're trying to achieve
   - **Context**: Relevant background
   - **Approach**: High-level strategy
   - **Tasks**: Numbered list of specific tasks
   - **Risks/Considerations**: Potential issues
   - **Success Criteria**: How we know we're done

- Filename: `control-plane-plan-301125-14_30.md`

