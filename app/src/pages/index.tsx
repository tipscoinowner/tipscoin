import ValueBanner from "@/components/ValueBanner";
import HealthStatus from "@/components/HealthStatus";

export default function HomePage() {
  const data = {
    targetUnitValue: 1.0,
    reserveRatio: 0.92,
    isHealthy: true,
  };

  return (
    <>
      <ValueBanner targetUnitValue={data.targetUnitValue} />

      <HealthStatus
        reserveRatio={data.reserveRatio}
        isHealthy={data.isHealthy}
      />
    </>
  );
}
