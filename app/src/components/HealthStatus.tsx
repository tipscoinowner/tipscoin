import React from "react";

type HealthStatusProps = {
  reserveRatio: number;
  isHealthy: boolean;
};

export default function HealthStatus({
  reserveRatio,
  isHealthy,
}: HealthStatusProps) {
  const statusColor = isHealthy ? "#16c784" : "#ea3943";
  const statusText = isHealthy ? "Healthy" : "Unhealthy";

  return (
    <div
      style={{
        padding: "16px",
        borderRadius: "12px",
        background: "#111",
        color: "#fff",
        border: `1px solid ${statusColor}`,
      }}
    >
      <div style={{ fontSize: "18px", fontWeight: 600, marginBottom: "8px" }}>
        Reserve Ratio: {(reserveRatio * 100).toFixed(2)}%
      </div>

      <div style={{ fontSize: "16px", color: statusColor }}>
        Status: {statusText}
      </div>
    </div>
  );
}
