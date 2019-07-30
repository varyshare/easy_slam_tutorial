function plot_state(mu, landmarks, timestep, z)
    % Visualizes the robot in the map.
    %
    % The resulting plot displays the following information:
    % - the landmarks in the map (black +'s)
    % - current robot pose (red)
    % - observations made at this time step (line between robot and landmark)

    clf
    hold on
    grid("on")
    L = struct2cell(landmarks);
    figure(1, "visible", "on");
    plot(cell2mat(L(2,:)), cell2mat(L(3,:)), 'k+', 'markersize', 10, 'linewidth', 5);

    for(i=1:size(z,2))
        id = z(i).id;
	mX = landmarks(id).x;
	mY = landmarks(id).y;
    	line([mu(1), mX],[mu(2), mY], 'color', 'b', 'linewidth', 1);
    endfor

    drawrobot(mu(1:3), 'r', 3, 0.3, 0.3);
    xlim([-2, 12])
    ylim([-2, 12])
    filename = sprintf('../plots/odom_%03d.png', timestep);
    print(filename, '-dpng');
    hold off
end
