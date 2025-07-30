Perform a systematic code review based on project coding standards.

**Input Requirements:**
- Target files/directories to review: $TARGET_FILES
- Path to coding standards document: $STANDARDS_DOC (default: ./Python.md)
- Review scope: modified files and other files related.

**Review Process:**

1. **Locate Coding Standards**
   - Read the coding standards document at the specified path
   - Find the "## Coding Styles" section (or similar heading)
   - If the document doesn't exist or lacks this section, report this and request guidance

2. **Organize Review Categories**
   - Extract each sub-section under "Coding Styles" as a review category
   - List all categories found (e.g., "Naming Conventions", "Code Structure", "Documentation")
   - If no sub-sections exist, report this.

3. **Systematic Code Review**
   For each coding style category:
   - Start a new sub-task using Claude MCP server
   - State the category being reviewed
   - List the specific guidelines from that category
   - Review each target file line-by-line for violations
   - Output the findings in the following format:

   Category: [Category Name]
    File: [filepath]
    Line: [line_number]
    Issue: [Brief description]
    Details: [Explain why this violates the guideline and its impact]


Remember: Your job is to diligently take a methodical, critical look at
the source code. Please refrain from suggesting or making code changes.