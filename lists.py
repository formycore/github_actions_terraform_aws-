raw_items = "assigned, unassigned, labeled, unlabeled, opened, edited, closed, reopened, synchronize, converted_to_draft, locked, unlocked, enqueued, dequeued, milestoned, demilestoned, ready_for_review, review_requested, review_request_removed, auto_merge_enabled, auto_merge_disabled"
#items = []
#print(raw_items.split(","))
for i in raw_items.split(","):
    print("-" + i)

