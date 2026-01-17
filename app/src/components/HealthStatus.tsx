import React from "react";

type Props = {
  reserveRatio: number; // percentage
  isHealthy: boolean;
};

export const HealthStatus: React.FC<Props> = ({ reserveRatio, isHealthy }) => {
  const color = isHealthy ? "green" : "red";
  const label = isHealthy ? "Healthy" : "Below Minimum";

  return (
    <div
      style={{
        padding: "14px",
        border: "1px solid #ddd",
        borderRadius: 8,
        background: "#fff",
        marginTop: 10,
      }}
    >
      <strong>Reserve Ratio:</strong> {reserveRatio.toFixed(2)}% —{" "}
      <span style={{ color, fontWeight: 600 }}>{label}</span>
    </div>
  );
};
