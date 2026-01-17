import React from "react";

type Props = {
  open: boolean;
  onClose: () => void;
  targetUnitValue: number;
  reserveRatio: number;
  minReserveRatio: number;
};

export const ReserveInfoModal: React.FC<Props> = ({
  open,
  onClose,
  targetUnitValue,
  reserveRatio,
  minReserveRatio,
}) => {
  if (!open) return null;

  return (
    <div
      style={{
        position: "fixed",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: "rgba(0,0,0,0.45)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        zIndex: 999,
      }}
    >
      <div
        style={{
          width: 420,
          background: "#fff",
          padding: 24,
          borderRadius: 12,
          boxShadow: "0 4px 20px rgba(0,0,0,0.2)",
        }}
      >
        <h2 style={{ marginTop: 0 }}>TIPSC Reserve Model</h2>

        <p>
          <strong>Target Value:</strong> 1 TIPSC ={" "}
          {targetUnitValue.toFixed(2)} Reference Units
        </p>

        <p>
          <strong>Current Reserve Ratio:</strong>{" "}
          {reserveRatio.toFixed(2)}%
        </p>

        <p>
          <strong>Minimum Required Ratio:</strong>{" "}
          {minReserveRatio.toFixed(2)}%
        </p>

        <p style={{ marginTop: 16, color: "#555" }}>
          TIPSC is a governance-defined institutional asset backed by
          on-chain reserves. The Reserve Manager enforces minimum reserve
          ratios and ensures TIPSC remains within healthy operational
          parameters.
        </p>

        <button
          onClick={onClose}
          style={{
            marginTop: 20,
            padding: "10px 18px",
            borderRadius: 6,
            border: "none",
            background: "#222",
            color: "#fff",
            cursor: "pointer",
          }}
        >
          Close
        </button>
      </div>
    </div>
  );
};
