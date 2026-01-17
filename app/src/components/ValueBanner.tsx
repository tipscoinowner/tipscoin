import React from "react";

type Props = {
  targetUnitValue: number;
};

export const ValueBanner: React.FC<Props> = ({ targetUnitValue }) => (
  <div
    style={{
      padding: "20px",
      border: "1px solid #222",
      borderRadius: 10,
      background: "#fafafa",
      marginBottom: 20,
    }}
  >
    <h2 style={{ margin: 0, fontSize: "1.6rem" }}>
      1 TIPSC = {targetUnitValue.toFixed(2)} Reference Units
    </h2>
    <p style={{ marginTop: 6, color: "#555" }}>
      Governance-defined target value, backed by on-chain reserves.
    </p>
  </div>
);
