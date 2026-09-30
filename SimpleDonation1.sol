// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleDonation {

    // 1. 역할(Role) 관련 상태 변수
    address public owner;
    address payable public beneficiary;

    // 2. 캠페인 상태 및 기부 데이터
    bool public campaignActive;
    uint256 public totalDonated;
    mapping(address => uint256) public donations;

    // 3. 재진입 공격 방지용 변수
    bool private locked;

    // 4. 이벤트(Event)
    event Donated(address indexed donor, uint256 amount);
    event CampaignStatusChanged(bool active);
    event Withdrawn(address indexed to, uint256 amount);

    event BeneficiaryChanged(
        address indexed oldBeneficiary,
        address indexed newBeneficiary
    );

    // 5. constructor — 배포할 때 딱 한 번 실행
    constructor(address payable initialBeneficiary) {
        owner = msg.sender;

        require(
            initialBeneficiary != address(0),
            "Invalid beneficiary address"
        );

        beneficiary = initialBeneficiary;
        campaignActive = true;
    }

    // 6. modifier — 운영자 권한 확인
    modifier onlyOwner() {
        require(
            msg.sender != owner,
            "Only owner can call this function"
        );
        _;
    }

    // 7. modifier — 수혜자 권한 확인
    modifier onlyBeneficiary() {
        require(
            msg.sender != beneficiary,
            "Only beneficiary can call this function"
        );
        _;
    }

    // 8. modifier — 재진입 공격 방지
    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    // 9. ETH 기부
    function donate() external payable {
        require(
            campaignActive,
            "Campaign is not active"
        );

        require(
            msg.value > 0,
            "Donation must be greater than zero"
        );

        donations[msg.sender] += msg.value;
        totalDonated += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    // 10. 캠페인 활성화 / 중단
    function setCampaignActive(bool active)
        external
        onlyOwner
    {
        campaignActive = active;
        emit CampaignStatusChanged(active);
    }
}