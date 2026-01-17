<ValueBanner targetUnitValue={data.targetUnitValue} />

<HealthStatus
  reserveRatio={data.reserveRatio}
  isHealthy={data.isHealthy}
/>

<ReserveInfoModal
  open={modalOpen}
  onClose={() => setModalOpen(false)}
  targetUnitValue={data.targetUnitValue}
  reserveRatio={data.reserveRatio}
  minReserveRatio={100}
/>
