#!/usr/bin/env python3
"""بررسی سلامت مجموعه مستندات MazanDasht EPR OS.

کارها:
  1) بررسی پیوندهای نسبی (لینک‌های شکسته)
  2) شمارش واژه‌ها و تخمین صفحات به تفکیک جلد
  3) بررسی یکتایی شناسه‌های سند (MD-XXX-001)
  4) بررسی ارجاع‌های شناسه‌ای (REQ-/BR-/JE-) که در سند تعریف نشده‌اند
  5) بررسی وجود بخش «پذیرش» در اسناد ماژول

اجرا:
    python3 tools/check_docs.py
"""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOCS = ROOT / "docs"

LINK_RE = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
DOC_ID_RE = re.compile(r"\bMD-[A-Z]{3}-\d{3}\b")
REQ_RE = re.compile(r"\bREQ-[FN]-\d{3}\b")
BR_RE = re.compile(r"\bBR-\d{3}\b")
JE_RE = re.compile(r"\bJE-[A-Z]{2,3}-\d{3}\b")
KPI_RE = re.compile(r"\bKPI-[A-Z]{3}-\d{3}\b")
RPT_RE = re.compile(r"\bRPT-[A-Z]{3}-\d{3}\b")
PRT_RE = re.compile(r"\bPRT-[A-Z]{2,4}-\d{2}\b")

VOLUMES = {
    "00-foundations": "جلد ۱ — بنیان‌ها",
    "architecture": "جلد ۲ — معماری",
    "accounting": "جلد ۳ — موتور مالی",
    "modules": "جلد ۴ — عملیات",
    "reports": "جلد ۵ — گزارش",
    "print": "جلد ۵ — چاپ",
    "ux": "جلد ۵ — تجربه کاربری",
    "security": "جلد ۵ — امنیت",
    "deployment": "جلد ۲ — استقرار",
    "data": "جلد ۶ — داده",
    "api": "جلد ۶ — API",
    "scenarios": "جلد ۶ — سناریوها",
    "adr": "تصمیم‌های معماری",
}


def md_files() -> list[Path]:
    return sorted(p for p in ROOT.rglob("*.md") if ".git" not in p.parts)


def word_count(text: str) -> int:
    return len(re.findall(r"[\w\u0600-\u06FF]+", text))


def check_links(files: list[Path]) -> list[str]:
    problems = []
    for path in files:
        text = path.read_text(encoding="utf-8")
        for raw in LINK_RE.findall(text):
            target = raw.split("#", 1)[0].strip()
            if not target or target.startswith(("http://", "https://", "mailto:")):
                continue
            resolved = (path.parent / target).resolve()
            if not resolved.exists():
                problems.append(f"{path.relative_to(ROOT)} → پیوند شکسته: {raw}")
    return problems


def check_doc_ids(files: list[Path]) -> list[str]:
    seen: dict[str, list[str]] = defaultdict(list)
    for path in files:
        for doc_id in DOC_ID_RE.findall(path.read_text(encoding="utf-8")):
            seen[doc_id].append(str(path.relative_to(ROOT)))
    return [
        f"شناسه تکراری {doc_id} در: {', '.join(paths)}"
        for doc_id, paths in seen.items()
        if len(paths) > 1
    ]


def collect_defined(files: list[Path], regex: re.Pattern[str]) -> set[str]:
    defined: set[str] = set()
    for path in files:
        defined.update(regex.findall(path.read_text(encoding="utf-8")))
    return defined


def check_acceptance(files: list[Path]) -> list[str]:
    """هر سند ماژول/جلد باید بخش پذیرش داشته باشد."""
    problems = []
    targets = [p for p in files if p.parent.name in VOLUMES
               and p.parent.name != "adr" and p.name != "README.md"]
    for path in targets:
        text = path.read_text(encoding="utf-8")
        if "پذیرش" not in text:
            problems.append(f"{path.relative_to(ROOT)} → بخش «پذیرش» ندارد")
    return problems


def stats(files: list[Path]) -> None:
    per_volume: dict[str, list[int]] = defaultdict(list)
    total_words = 0
    total_tables = 0
    for path in files:
        text = path.read_text(encoding="utf-8")
        words = word_count(text)
        total_words += words
        total_tables += len(re.findall(r"^\|.*\|$", text, flags=re.M))
        key = path.parent.name if path.parent.name in VOLUMES else "سایر"
        per_volume[key].append(words)

    print("=" * 72)
    print("آمار مستندات")
    print("=" * 72)
    print(f"تعداد فایل markdown: {len(files)}")
    print(f"تعداد واژه: {total_words:,}")
    print(f"تخمین صفحه (۲۵۰ واژه/صفحه): {total_words // 250:,}")
    print(f"تعداد سطر جدول: {total_tables:,}")
    print("-" * 72)
    for key in sorted(per_volume):
        label = VOLUMES.get(key, "سایر")
        words = sum(per_volume[key])
        print(f"  {label:<28} {len(per_volume[key]):>3} فایل  {words:>8,} واژه  ~{words // 250:>4} صفحه")
    print("=" * 72)


def main() -> int:
    files = md_files()
    if not files:
        print("هیچ فایل markdown یافت نشد.")
        return 1

    stats(files)

    defined_req = collect_defined(files, REQ_RE)
    defined_br = collect_defined(files, BR_RE)
    defined_je = collect_defined(files, JE_RE)

    problems: list[str] = []
    problems += check_links(files)
    problems += check_doc_ids(files)
    problems += check_acceptance(files)

    print("\nشناسه‌های تعریف‌شده:")
    print(f"  نیازمندی: {len(defined_req)} · قاعده کسب‌وکار: {len(defined_br)} · سند خودکار: {len(defined_je)}")
    print(f"  KPI: {len(collect_defined(files, KPI_RE))} · گزارش: {len(collect_defined(files, RPT_RE))} · قالب چاپ: {len(collect_defined(files, PRT_RE))}")

    if problems:
        print(f"\nمشکلات ({len(problems)}):")
        for p in problems:
            print(f"  ✗ {p}")
        return 1

    print("\n✓ هیچ پیوند شکسته، شناسه تکراری یا سند بدون بخش پذیرش یافت نشد.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
