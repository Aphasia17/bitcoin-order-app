#!/bin/bash
set -eu

mkdir -p zap-reports
chmod 777 zap-reports

docker pull ghcr.io/zaproxy/zaproxy:stable

scan_status=0
docker run --rm \
  -v "$PWD/zap-reports:/zap/wrk/:rw" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py \
  -t "https://aphasia17.github.io/bitcoin-order-app/" \
  -l PASS \
  -r zap_baseline_report.html || scan_status=$?

case "$scan_status" in
  0|1|2)
    echo "Scan completed with status $scan_status; review the HTML report."
    ;;
  *)
    echo "ZAP could not complete the scan."
    exit "$scan_status"
    ;;
esac

test -s zap-reports/zap_baseline_report.html
