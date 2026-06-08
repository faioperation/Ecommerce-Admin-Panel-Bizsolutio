import re

files = [
    "lib/features/users/presentation/pages/users_page.dart",
    "lib/features/sellers/presentation/pages/sellers_page.dart",
    "lib/features/products/presentation/pages/products_page.dart",
    "lib/features/reports/presentation/pages/reports_page.dart",
    "lib/features/notifications/presentation/pages/notifications_page.dart",
    "lib/features/support/presentation/pages/support_tickets_page.dart",
]

for filepath in files:
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Replace 'width: <number>' with 'minimumWidth: <number>'
        # Only if it's inside a GridColumn or just generally replace width: \d+ if it's not SizedBox
        # Actually it's just 'width: \d+,' inside these pages.
        new_content = re.sub(r'width:\s*(\d+(?:\.\d+)?),', r'minimumWidth: \1,', content)
        
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Updated {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
