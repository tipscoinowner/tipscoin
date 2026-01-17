import React from "react";

type ValueBannerProps = {
  targetUnitValue: number;
};

export default function ValueBanner({ targetUnitValue }: ValueBannerProps) {
  return (
    <div
      style={{
        padding: "16px",
        borderRadius: "12px",
        background: "#111",
        color: "#fff",
        fontSize: "20px",
        fontWeight: 600,
        textAlign: "center",
        border: "1px solid #222",
      }}
    >
      Target Unit Value: {targetUnitValue.toFixed(4)}
    </div>
  );
}
