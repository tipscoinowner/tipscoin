coin-chain/
├─ contracts/
│  ├─ COIN.sol
│  ├─ ReserveManager.sol
│  ├─ Governance.sol
│  └─ interfaces/
│     ├─ IReserveManager.sol
│     └─ IGovernance.sol
│
├─ app/
│  ├─ src/
│  │  ├─ components/
│  │  │  ├─ ValueBanner.tsx
│  │  │  ├─ HealthStatus.tsx
│  │  │  └─ ReserveInfoModal.tsx
│  │  ├─ pages/
│  │  │  └─ index.tsx
│  │  ├─ adapters/
│  │  │  └─ valueAdapter.ts
│  │  └─ config/
│  │     └─ contracts.ts
│  └─ package.json
│
├─ docs/
│  ├─ COIN_Value_Model_Overview.md
│  ├─ COIN_Governance_and_Risk_Policy.md
│  └─ COIN_UI_Value_Presentation.md
│
├─ scripts/
│  ├─ deploy.ts
│  └─ demoPopulate.ts
│
├─ hardhat.config.ts
├─ package.json
└─ README.md
